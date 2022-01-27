#!/bin/bash
set -euo pipefail

# https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/declarative-setup.md

# Install argocd with root app using kubectl current config
# IMPORTANT: Make sure your kubeconfig is set correctly
# Also this script must be run from the root of the argocd-apps repo

##### Prerequisite and argument checks #####
# This script requires: kubectl, kubeseal, helm, bcrypt-tool, pwgen

##### Flow #####
# Setup K8s
# Setup Sealed secret
# Setup Argocd
# Setup Root app in argocd

CANCEL_INSTALL() {
    echo "Canceling install"
    exit 1
}

DEPFAIL() {
    echo "ERROR missing dependency: $1"
    echo "See wiki/guides/kubernetes-desktop-setup.md for how to install it"
    CANCEL_INSTALL
}

# We should be in the root of the argocd-apps repo
CWDFAIL() {
    echo "ERROR missing folder: $1"
    echo "You must run this script in the root of the argocd-apps repo"
    CANCEL_INSTALL
}

ARGFAIL() {
    echo -n "
Usage $0 [OPTION]:
  --cluster-name                  full cluser-name                          [Required]
  --customer-id                   customer ID of obmondo customer           [Required]
  --recovery                      true|false [Defaults: false]
  --private-key-path              sealed-secrets-private-keys-dir           [Required when --recovery]
  --public-key-path               sealed-secrets-public-keys-dir            [Required when --recovery]
  --install-k8s                   install kubernetes cluster [Defaults: true]
  --k8s-type                      bare [self managed or via puppet],
                                  aws-kops [k8s cluster with kops on aws],
                                  aks-terraform [azure k8s with terraform]  [Required, unless --install-k8s false]
  --settings-file                 path to settings-files                    [Required]
  --setup-argocd                  setup argocd
  --setup-sealed-secret           setup sealed secret
  --setup-root-app                setup root app to manage other app
  --generate-argocd-password      generate admin password for argocd
  --dump-sealedsecrets-keys-certs dump the private key and public certs     [Optional]
  -h | --help

Example:
# $0 --cluster-name your-cluster-name
"
}

HEAD() {
    echo -n -e "\e[1;35m $1 \e[0m \t...\e[0m"
}

STAT() {
    if [ "$1" -eq 0 ]; then
        echo -e "\e[1;32m Done\e[0m"
    else
        echo -e "\e[1;32m Error\e[0m"
        echo -e "\e[1;33m CHECK THE LOG FILE FOR MORE DETAILS: /tmp/argocd.log \e[0m"
        exit 1
    fi
}

DEFAULT_VALES() {
  KEY=$1
  DEFAULT=$2

  # If the value is not found, the take the default value
  if YAML_VALUES=$(yq eval --exit-status "$KEY" "$SETTINGS_FILE" 2>/dev/null); then
    echo "$YAML_VALUES"
  else
    if [ -z "$DEFAULT" ]; then
        echo "Error: missing key in the yaml file"
    else
        echo "$DEFAULT"
    fi
  fi
}

if [[ $# -eq 0 ]]; then
  ARGFAIL
  exit 0
fi

##### Get user inputs #####
declare RECOVERY=false
declare INSTALL_K8S=true
declare K8S_TYPE=
declare SETUP_ARGOCD=true
declare SETUP_SEALED_SECRET=true
declare SETUP_ROOT_APP=true
declare PRIVATE_KEY_PATH=
declare PUBLIC_CERT_PATH=
declare CLUSTER_NAME=
declare GENERATE_ARGOCD_PASSWORD=true
declare SEALEDSECRETS_KEYS_CERTS=false
declare CUSTOMER_ID=

while [[ $# -gt 0 ]]; do
    arg="$1"
    shift

    case "$arg" in
      --cluster-name)
          CLUSTER_NAME=$(echo "$1" | tr '[:upper:]' '[:lower:]') # Convert to lower case
          shift
          ;;
      --recovery)
          RECOVERY=true
          ;;
      --private-key-path)
          PRIVATE_KEY_PATH=$1
          if ! $RECOVERY && [ -n "$PRIVATE_KEY_PATH" ]; then
              echo "Specified private keys dir, but this is not recovery mode!"
              exit 1
          fi
          shift
          ;;
      --public-key-path)
          PUBLIC_CERT_PATH=$1
          if ! $RECOVERY && [ -n "$PUBLIC_CERT_PATH" ]; then
              echo "Specified public cert dir, but this is not recovery mode!"
              exit 1
          fi
          shift
          ;;
      --settings-file)
          SETTINGS_FILE=$1

          if [ ! -f "$SETTINGS_FILE" ]; then
              echo "Given $SETTINGS_FILE does not exists, please check it"
              exit 1
          fi

          shift
          ;;
      --install-k8s)
          INSTALL_K8S=$1
          shift
          ;;
      --k8s-type)
          K8S_TYPE=$1
          shift
          ;;
      --setup-argocd)
          SETUP_ARGOCD=$1
          shift
          ;;
      --setup-root-app)
          SETUP_ROOT_APP=$1
          shift
          ;;
      --setup-sealed-secret)
          SETUP_SEALED_SECRET=$1
          shift
          ;;
      --generate-argocd-password)
          GENERATE_ARGOCD_PASSWORD=$1
          shift
          ;;
      --dump-sealedsecrets-keys-certs)
          SEALEDSECRETS_KEYS_CERTS=$1
          shift
          ;;
      --customer-id)
          CUSTOMER_ID=$1
          shift
          ;;
      -h|--help)
          ARGFAIL
          exit
          ;;
      *)
          echo "Error: wrong argument given"
          ARGFAIL
          exit 1
          ;;
    esac
done

for program in kubectl kubeseal helm bcrypt-tool pwgen yq
do
    if ! command -v "$program" >/dev/null; then
        DEPFAIL $program
    fi
done

if [ -z "$SETTINGS_FILE" ]; then
    echo "Missing required arguments"
    ARGFAIL
    exit 1
fi

if [ -z "$CUSTOMER_ID" ]; then
    echo "--customer-id is missing in the argument list"
    exit 1
fi

# If cluster name is not given in the args list, pick it up from the settings file
if [ -z "$CLUSTER_NAME" ]; then
    if yq e -e '.cluster.name' "$SETTINGS_FILE" &>/dev/null; then
        CLUSTER_NAME=$(yq e '.cluster.name' "$SETTINGS_FILE" | tr '[:upper:]' '[:lower:]') # Convert to lower case
    else
        echo "no cluster.name is given in the customer-settings files, please give one"
       exit 1
    fi
fi

## Get some values from the settings file
CUSTOMER_CONFIG_DIR="../kubernetes-config-${CUSTOMER_ID}/${CLUSTER_NAME}"
CUSTOMER_REPO_URL=$(yq eval '.argo-cd.repo.url' "$SETTINGS_FILE")
OCI_URL=$(yq eval '.argo-cd.repo.oci' "$SETTINGS_FILE")
GIT_AUTH_TYPE=$(yq eval '.argo-cd.repo.auth.git' "$SETTINGS_FILE")
GIT_AUTH_URL=$(yq eval '.argo-cd.repo.auth.url' "$SETTINGS_FILE")
ARGOCD_SECRET_NAME=argocd-"$CLUSTER_NAME"-admin
ARGOCD_APPS="${CUSTOMER_CONFIG_DIR}/argocd-apps"
ARGOCD_APPS_TEMPLATE="${CUSTOMER_CONFIG_DIR}/argocd-apps/templates"
EXTERNAL_VALUE_GIT_REPO_URL=$(echo "${CUSTOMER_REPO_URL}" | sed -e 's/\//_/g' -e 's/:/_/g')
OBMONDO_ARGOCD_REPO="https://gitlab.enableit.dk/kubernetes/argocd-apps.git"

if $INSTALL_K8S; then
    case "$K8S_TYPE" in
      puppet)
        echo "you can run ./bin/generate-puppet-hiera.sh"
      ;;
      aws-kops)
          CLUSTER_CONFIG_DIR=$(yq e '.cluster.configDir' "$SETTINGS_FILE")
          SHORT_CLUSTER_NAME=$(yq eval '.cluster.shortName' "$SETTINGS_FILE")

          # Setup the Cluster with KOPS
          echo "Creating cluster $CLUSTER_NAME with KOPS on AWS"
          ./bin/k8s-install-kops.sh \
            --cluster-config-path "$CLUSTER_CONFIG_DIR" \
            --cluster-name "$CLUSTER_NAME"

          # Restore the private keys from, to enable secrets manage to actually decrypt the SealedSecrets
          if $RECOVERY; then
              aws secretsmanager get-secret-value --secret-id sealed-secrets-"$SHORT_CLUSTER_NAME" | jq -re '.SecretString' | base64 -d | gzip -cd | kubectl create -f -
          fi

      ;;
      aks-terraform)
          echo "We dont't support aks-terraform as of now. but wait tight. its coming soon"
          exit 0
      ;;
      *)
          echo "Unsupported $K8S_TYPE k8s-type given, which we don't understand. exiting"
          ARGFAIL
          exit 1
      ;;
    esac
fi

# Print kubeconfig warning
echo "Installing argocd on the cluster in your current kubeconfig!"
echo "You better have switched to the right one!"
export HELM_EXPERIMENTAL_OCI=1

##### Install sealed secrets #####
if $SETUP_SEALED_SECRET; then

    mkdir -p "${ARGOCD_APPS_TEMPLATE}"

    # Create system namespace if it doesnt exist
    if ! kubectl get namespaces system &>/dev/null; then
        HEAD "Creating system namespace...        "
        kubectl create namespace system &>>/tmp/argocd.log
        STAT $?
    fi

    if $SEALEDSECRETS_KEYS_CERTS; then
        echo "Going to dump the public certs in ./public_certs dir and private keys in ./private_keys dir"
        mkdir -p public_certs private_keys

        for s in $(kubectl get -n system secrets | grep key | cut -d " " -f 1); do
            kubectl get -n system secret "$s" -o yaml | yq eval '.data."tls.crt"' - | base64 -d > public_certs/"$s".crt
            kubectl get -n system secret "$s" -o yaml | yq eval '.data."tls.key"' - | base64 -d > private_keys/"$s".key
        done
        exit 0
    fi

    ##### Recovery mode checks #####
    # Cancel if not recovery mode and cluster folder exists or if in recovery mode and some manifests are missing
    if $RECOVERY; then

        if [ ! -d "$PRIVATE_KEY_PATH" ] && [ ! -d "$PUBLIC_CERT_PATH" ]; then
            echo "Private key path is missing $PRIVATE_KEY_PATH or Public cert path is missing $PUBLIC_CERT_PATH"
            CANCEL_INSTALL
        fi

        echo "Using recovery mode: Existing manifests will be used."
        for required_folder in \
            "${ARGOCD_APPS}" \
            "${ARGOCD_APPS_TEMPLATE}" \
            "${CUSTOMER_CONFIG_DIR}/sealed-secrets"
        do
            if [[ ! -d "$required_folder" ]]; then
                echo "ERROR in recovery mode, missing $required_folder"
                echo "You must run recovery mode in an argocd-apps branch where this cluster was installed successfully once"
                CANCEL_INSTALL
            fi
        done

        for required_file in \
            "${ARGOCD_APPS}/Chart.yaml" \
            "${ARGOCD_APPS_TEMPLATE}/root.yaml"
        do
            if [ ! -f "$required_file" ]; then
                echo "ERROR in recovery mode, missing $required_file"
                echo "you must run recovery mode in an argocd-apps branch where this cluster was installed successfully once"
                CANCEL_INSTALL
            fi
        done

        # Import old sealed-secrets private keys
        for keypath in "$PRIVATE_KEY_PATH"/*.key; do
            secret_name=$(basename "${keypath%.*}")
            if ! kubectl get secret -n system "$secret_name" -o name &>/dev/null; then
                kubectl -n system create secret tls "$secret_name" --cert="${PUBLIC_CERT_PATH}/${secret_name}.crt" --key="$keypath" &>>/tmp/argocd.log
                kubectl -n system label secret "$secret_name" sealedsecrets.bitnami.com/sealed-secrets-key=active &>>/tmp/argocd.log
            fi
        done
    fi

    # Switch local helm chart to use upstream repo instead of OCI cache
    if ! helm list --deployed -n system -q | grep sealed-secrets >/dev/null; then
        yq eval -i '.dependencies.[].repository = "https://bitnami-labs.github.io/sealed-secrets"' ./argocd-helm-charts/sealed-secrets/Chart.yaml

        HEAD "Installing sealed-secrets... "
        helm dep update ./argocd-helm-charts/sealed-secrets &>>/tmp/argocd.log

        cp ./argocd-application-templates/sealed-secrets.yaml "${ARGOCD_APPS_TEMPLATE}/sealed-secrets.yaml"

        # this is already in the template files, but adding it incase someone screw the template file
        yq eval --inplace ".spec.destination.namespace = system" "${ARGOCD_APPS_TEMPLATE}/sealed-secrets.yaml"
        yq eval --inplace ".spec.source.repoURL = \"$OBMONDO_ARGOCD_REPO\"" "${ARGOCD_APPS_TEMPLATE}/sealed-secrets.yaml"
        yq eval --inplace ".spec.source.helm.valueFiles.[1] = \"/tmp/${EXTERNAL_VALUE_GIT_REPO_URL}/$CLUSTER_NAME/argocd-apps/values-sealed-secrets.yaml\"" "${ARGOCD_APPS_TEMPLATE}/sealed-secrets.yaml"

        # Lets touch a file, so sealed-secret is not broken when its getting synced from argocd
        # some customer has their specific sealed-secret, so touch won't do any harm in case of recovery as well
        touch "${ARGOCD_APPS}/values-sealed-secrets.yaml"

        helm install \
            --namespace system \
            --values argocd-helm-charts/sealed-secrets/values.yaml \
            --values "${ARGOCD_APPS}/values-sealed-secrets.yaml" \
            sealed-secrets argocd-helm-charts/sealed-secrets &>>/tmp/argocd.log

        STAT $?
    else
        HEAD "sealed-secrets is already installed... "
        STAT $?
    fi

    # Create required directory
    mkdir -p "${CUSTOMER_CONFIG_DIR}/sealed-secrets/argocd"

    # Switch to the original state of the file, after installing
    git restore ./argocd-helm-charts/sealed-secrets/Chart.yaml
fi

##### Install argocd #####
if $SETUP_ARGOCD; then

    if ! kubectl -n system get pods -l 'app.kubernetes.io/name=sealed-secrets' -o jsonpath="{..status.containerStatuses[0].ready}" >/dev/null; then
        echo "Error: seems like sealed-secrets pods are not running.":
        echo "cannot install argocd app without sealed-secret.. exiting"
        exit 1
    fi

    mkdir -p "${ARGOCD_APPS_TEMPLATE}"

    ### Need to add steps, if we are recovering argocd ####
    if ! kubectl get namespaces argocd &>/dev/null; then
        HEAD "Creating argocd namespace...        "
        kubectl create namespace argocd &>>/tmp/argocd.log
        STAT $?
    fi

    SEALEDSECRET_CRT="${CUSTOMER_CONFIG_DIR}/$CLUSTER_NAME.pem"
    SEALEDSECRET_ARGOCD="${CUSTOMER_CONFIG_DIR}/sealed-secrets/argocd"
    ARGOCD_CTRL_REPLICAS=$(DEFAULT_VALES '.argo-cd.controller.replicas' 1)
    ARGOCD_REPO_REPLICAS=$(DEFAULT_VALES '.argo-cd.repoServer.replicas' 1)
    ARGOCD_REPO_NAME=$(yq eval '.argo-cd.repo.name' "$SETTINGS_FILE")

    # This is the form in which argocd stores its admin password
    PASSWORD=$(pwgen -y 30 1)
    SECRET_KEY=$(pwgen 48 1)
    ENCODED_PASSWORD_HASH=$(bcrypt-tool hash "$PASSWORD" 10)

    kubectl get secret \
        --namespace system \
        -l sealedsecrets.bitnami.com/sealed-secrets-key=active \
        -o jsonpath='{'.items[0].data."tls\.crt"'}' \
        | base64 -d > "${SEALEDSECRET_CRT}"

    # Add Obmondo.com argocd-apps repo, which holds all the helm apps
    # This repo is common for all customers.
    if ! "$RECOVERY" && ! kubectl get secrets -n argocd obmondo-argocd-common-repo -o name &>/dev/null; then
        HEAD "Adding argocd-apps repo...   "
        read -r -p "Username: " OBMONDO_ARGOCD_REPO_USERNAME
        read -r -s -p "Password: " OBMONDO_ARGOCD_REPO_PASSWORD

        kubectl create secret generic obmondo-argocd-common-repo \
            --namespace=argocd \
            --dry-run=client \
            --from-literal=type='git' \
            --from-literal=name='obmondo-argocd-apps' \
            --from-literal=url="$OBMONDO_ARGOCD_REPO" \
            --from-literal=username="$OBMONDO_ARGOCD_REPO_USERNAME" \
            --from-literal=password="$OBMONDO_ARGOCD_REPO_PASSWORD" \
            --output yaml \
            | yq eval '.metadata.labels.["argocd.argoproj.io/secret-type"]="repository"' - \
            | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - \
            | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - \
            | kubeseal --controller-namespace system \
            --controller-name sealed-secrets \
            --cert "${SEALEDSECRET_CRT}" \
            --format yaml \
            - > "${SEALEDSECRET_ARGOCD}/obmondo-argocd-common-repo.yaml"
        STAT $?
    fi

    HEAD "Applying sealed-secrets for obmondo-argocd-common-repo ...   "
    kubectl apply --namespace argocd -f "${SEALEDSECRET_ARGOCD}/obmondo-argocd-common-repo.yaml" &>>/tmp/argocd.log
    kubectl get secret --namespace argocd obmondo-argocd-common-repo >/dev/null
    STAT $?

    case "$GIT_AUTH_TYPE" in
        https)
            if ! "$RECOVERY" && ! kubectl get secrets -n argocd "$ARGOCD_SECRET_NAME" -o name &>/dev/null; then
                HEAD "Adding argocd-apps repo...   "
                # It can support tls as well, leaving it for next time
                read -r -p "Username: " HTTPS_USERNAME
                read -r -s -p "Password: " HTTPS_PASSWORD

                kubectl create secret generic "$ARGOCD_SECRET_NAME" \
                    --namespace=argocd \
                    --dry-run=client \
                    --from-literal=type='git' \
                    --from-literal=name="$ARGOCD_REPO_NAME" \
                    --from-literal=url="$CUSTOMER_REPO_URL" \
                    --from-literal=username="$HTTPS_USERNAME" \
                    --from-literal=password="$HTTPS_PASSWORD" \
                    --output yaml \
                    | yq eval '.metadata.labels.["argocd.argoproj.io/secret-type"]="repository"' - \
                    | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - \
                    | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - \
                    | kubeseal --controller-namespace system \
                    --controller-name sealed-secrets \
                    --cert "${SEALEDSECRET_CRT}" \
                    - > "${SEALEDSECRET_ARGOCD}/${ARGOCD_SECRET_NAME}".json
                STAT $?
            fi

            HEAD "Applying sealed-secrets for $ARGOCD_SECRET_NAME ...   "
            kubectl apply --namespace argocd -f "${SEALEDSECRET_ARGOCD}/${ARGOCD_SECRET_NAME}".json &>>/tmp/argocd.log
            kubectl get secret --namespace argocd "$ARGOCD_SECRET_NAME" >/dev/null
            STAT $?

            ### Update the argocd-secret with our custom password and create a sealed secret file as well
            if $GENERATE_ARGOCD_PASSWORD && ! $RECOVERY && ! kubectl get secrets -n argocd argocd-secret -o name &>/dev/null; then
                kubectl create secret generic argocd-secret \
                    --namespace=argocd \
                    --dry-run=client \
                    --from-literal=admin.password="$ENCODED_PASSWORD_HASH" \
                    --from-literal=admin.passwordMtime="$(date +%FT%T%Z)" \
                    --from-literal=server.secretkey="$SECRET_KEY" \
                    --output yaml \
                    | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - \
                    | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - \
                    | kubeseal --controller-namespace system \
                    --controller-name sealed-secrets \
                    --cert "${SEALEDSECRET_CRT}" \
                    - > "${SEALEDSECRET_ARGOCD}/argocd-secret.json"
                STAT $?

                echo "Argocd password: $PASSWORD"
            fi

            HEAD "Applying sealed-secrets for argocd-secret...   "
            kubectl apply --namespace argocd -f "${SEALEDSECRET_ARGOCD}/argocd-secret.json" &>>/tmp/argocd.log
            kubectl get secret --namespace argocd argocd-secret >/dev/null
            STAT $?

            ;;
        github)
            # https://docs.github.com/en/developers/apps/building-github-apps/authenticating-with-github-apps#generating-a-private-key
            if ! "$RECOVERY" && ! kubectl get secrets -n argocd "$ARGOCD_SECRET_NAME" -o name &>/dev/null; then
                HEAD "Creating sealed-secret for $ARGOCD_SECRET_NAME ...  "
                read -r -p "Github AppID: " GITHUB_APP_ID
                read -r -p "Github AppInstallationID: " GITHUB_APP_INSTALL_ID
                read -r -p "Github AppPrivateKey File: " GITHUB_APP_PRIVATEKEY

                if [ ! -f "$GITHUB_APP_PRIVATEKEY" ]; then
                    echo "Error: given $GITHUB_APP_PRIVATEKEY file does not exist"
                    exit 1
                fi

                kubectl create secret generic "$ARGOCD_SECRET_NAME" \
                    --namespace=argocd \
                    --dry-run=client \
                    --from-literal=url="$GIT_AUTH_URL" \
                    --from-literal=githubAppID="$GITHUB_APP_ID" \
                    --from-literal=githubAppInstallationID="$GITHUB_APP_INSTALL_ID" \
                    --from-file=githubAppPrivateKey="$GITHUB_APP_PRIVATEKEY" \
                    --output yaml \
                    | yq eval '.metadata.labels.["argocd.argoproj.io/secret-type"]="repo-creds"' - \
                    | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - \
                    | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - \
                    | kubeseal --controller-namespace system \
                    --controller-name sealed-secrets \
                    --cert "${SEALEDSECRET_CRT}" \
                    - > "${SEALEDSECRET_ARGOCD}/${ARGOCD_SECRET_NAME}".json
                STAT $?
            fi

            HEAD "Applying sealed-secrets for $ARGOCD_SECRET_NAME ...   "
            kubectl apply --namespace argocd -f "${SEALEDSECRET_ARGOCD}/${ARGOCD_SECRET_NAME}".json &>>/tmp/argocd.log
            kubectl get secret --namespace argocd "$ARGOCD_SECRET_NAME" >/dev/null
            STAT $?

            ### Update the argocd-secret with our custom password and create a sealed secret file as well
            if $GENERATE_ARGOCD_PASSWORD && ! $RECOVERY && ! kubectl get secrets -n argocd argocd-secret -o name &>/dev/null; then
                HEAD "Creating sealed-secret for argocd-secret ...    "
                read -r -s -p "Github client secret :" GITHUB_CLIENT_SECRET

                kubectl create secret generic argocd-secret \
                    --namespace=argocd \
                    --dry-run=client \
                    --from-literal=admin.password="$ENCODED_PASSWORD_HASH" \
                    --from-literal=admin.passwordMtime="$(date +%FT%T%Z)" \
                    --from-literal=github.clientSecret="$GITHUB_CLIENT_SECRET" \
                    --from-literal=server.secretkey="$SECRET_KEY" \
                    --output yaml \
                    | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - \
                    | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - \
                    | kubeseal --controller-namespace system \
                    --controller-name sealed-secrets \
                    --cert "${SEALEDSECRET_CRT}" \
                    - > "${SEALEDSECRET_ARGOCD}/argocd-secret.json"
                STAT $?

                echo "Argocd password: $PASSWORD"
            fi

            HEAD "Applying sealed-secrets for argocd-secret...   "
            kubectl apply --namespace argocd -f "${SEALEDSECRET_ARGOCD}/argocd-secret.json" &>>/tmp/argocd.log
            kubectl get secret --namespace argocd argocd-secret >/dev/null
            STAT $?

            ;;
        ssh)
            echo "Error: we don't recommend using ssh options, since a user can get shell access with ssh access"
            exit 1
            ;;
        *)
            echo "Unknown Git server is given, we only support gitlab and github"
            exit 1
            ;;
    esac

    # Setup only when OCI repo is given
    if [ -n "$OCI_URL" ]; then
        if ! $RECOVERY && ! kubectl get secrets -n argocd helm-repos-cache -o name &>/dev/null; then
            HEAD "Creating sealed-secret for OCI repo ...    "
            read -r -p "OCI repo username :" OCI_USERNAME
            read -r -s -p "OCI repo password :" OCI_PASSWORD

            kubectl create secret generic helm-repos-cache \
                --namespace=argocd \
                --dry-run=client \
                --from-literal=username="$OCI_USERNAME" \
                --from-literal=password="$OCI_PASSWORD" \
                --output yaml \
                | yq eval '.metadata.labels.["argocd.argoproj.io/instance"]="secrets"' - \
                | kubeseal --controller-namespace system \
                --controller-name sealed-secrets \
                --cert "${SEALEDSECRET_CRT}" \
                - > "${SEALEDSECRET_ARGOCD}/helm-repos-cache.json"
            STAT $?
        fi

        HEAD "Applying sealed-secrets for OCI repo...   "
        kubectl apply --namespace argocd -f "${SEALEDSECRET_ARGOCD}/helm-repos-cache.json" &>>/tmp/argocd.log
        kubectl get secret --namespace argocd helm-repos-cache >/dev/null
        STAT $?
    fi

    if ! helm list --deployed -n argocd -q | grep argo-cd >/dev/null; then
        yq eval -i '.dependencies.[].repository = "https://argoproj.github.io/argo-helm"' ./argocd-helm-charts/argo-cd/Chart.yaml

        HEAD "Installing argocd...         "
        helm dep update ./argocd-helm-charts/argo-cd &>> /tmp/argocd.log

        cp ./argocd-application-templates/argo-cd.yaml "${ARGOCD_APPS_TEMPLATE}/argo-cd.yaml"

        # this is already in the template files, but adding it incase someone screw the template file
        yq eval --inplace ".spec.destination.namespace = argocd" "${ARGOCD_APPS_TEMPLATE}/argo-cd.yaml"
        yq eval --inplace ".spec.source.repoURL = \"$OBMONDO_ARGOCD_REPO\"" "${ARGOCD_APPS_TEMPLATE}/argo-cd.yaml"
        yq eval --inplace ".spec.source.helm.valueFiles.[1] = \"/tmp/${EXTERNAL_VALUE_GIT_REPO_URL}/${CLUSTER_NAME}/argocd-apps/values-argo-cd.yaml\"" "${ARGOCD_APPS_TEMPLATE}/argo-cd.yaml"

        touch "${ARGOCD_APPS}/values-argo-cd.yaml"

        # We want to setup the secret via sealed-secret, so we should make it default to false
        # so argocd does not create argocd-secret and we create it ourselves.
        # --values (or -f): Specify a YAML file with overrides. This can be specified multiple times and the rightmost file will take precedence
        helm install \
            --namespace argocd \
            --set argo-cd.configs.secret.createSecret=false \
            --set argo-cd.controller.replicas="$ARGOCD_CTRL_REPLICAS" \
            --set argo-cd.repoServer.replicas="$ARGOCD_REPO_REPLICAS" \
            --values argocd-helm-charts/argo-cd/values.yaml \
            --values "${ARGOCD_APPS}/values-argo-cd.yaml" \
            argo-cd ./argocd-helm-charts/argo-cd &>> /tmp/argocd.log

        STAT $?
    else
        HEAD "argocd is already installed... "
        STAT $?
    fi

    # Switch to the original state of the file, after installing
    git restore ./argocd-helm-charts/argo-cd/Chart.yaml

    rm -fr "${SEALEDSECRET_CRT}"
fi

##### Install root app #####
if $SETUP_ROOT_APP; then
    if ! $RECOVERY; then
        HEAD "Writing root app manifests..."
        mkdir -p "${ARGOCD_APPS_TEMPLATE}"

        cp ./argocd-application-templates/Chart.yaml "${ARGOCD_APPS}/Chart.yaml"
        cp ./argocd-application-templates/root.yaml "${ARGOCD_APPS_TEMPLATE}/root.yaml"

        # Edit the yaml in place with required settings
        yq eval --inplace ".spec.source.path = \"${CLUSTER_NAME}/argocd-apps\"" "${ARGOCD_APPS_TEMPLATE}/root.yaml"
        yq eval --inplace ".spec.source.repoURL = \"$CUSTOMER_REPO_URL\"" "${ARGOCD_APPS_TEMPLATE}/root.yaml"

        STAT $?
    fi

    HEAD "Installing root app...       "
    helm template "${ARGOCD_APPS}" --show-only templates/root.yaml | kubectl apply -f - &>>/tmp/argocd.log
    STAT $?
fi

## Let's delete the initial-admin-secret secret, so we can have the one we want.
if kubectl get secret -n argocd argocd-initial-admin-secret -o name &>/dev/null; then
    kubectl -n argocd delete secret/argocd-initial-admin-secret &>>/tmp/argocd.log
fi

rm -fr "${SEALEDSECRET_CRT}"

echo "Installation finished"
