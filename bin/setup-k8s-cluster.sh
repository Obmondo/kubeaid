#!/bin/bash
set -euo pipefail

# https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/declarative-setup.md

# Install argocd with root app using kubectl current config
# IMPORTANT: Make sure your kubeconfig is set correctly
# Also this script must be run from the root of the argocd-apps repo

# For public cert
# for s in $(kubectl get -n system secrets | grep key | cut -d " " -f 1); do kubectl get -n system secret $s -o yaml | yq eval '.data."tls.crt"' - | base64 -d  > $s.crt; done

# For private key
# for s in $(kubectl get -n system secrets | grep key | cut -d " " -f 1); do kubectl get -n system secret $s -o yaml | yq eval '.data."tls.key"' - | base64 -d  > $s.key; done

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
  --cluster-name             full cluser-name                          [Required]
  --recovery                 true|false [Defaults: false]
  --private-key-path         sealed-secrets-private-keys-dir           [Required when --recovery]
  --public-key-path          sealed-secrets-public-keys-dir            [Required when --recovery]
  --install-k8s              install kubernetes cluster
  --k8s-type                 bare [self managed or via puppet],
                             aws-kops [k8s cluster with kops on aws],
                             aks-terraform [azure k8s with terraform]  [Optional]
  --settings-file            path to settings-files                     [Required]
  --setup-argocd             setup argocd
  --setup-sealed-secret      setup sealed secret
  --setup-root-app           setup root app to manage other app
  --generate-argocd-password generate admin password for argocd
  -h | --help

Example:
# $0 --name your-cluster-name
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
declare PUBLIC_KEY_PATH=
declare CLUSTER_NAME=
declare PREFLIGHT_CHECK=true
declare GENERATE_ARGOCD_PASSWORD=true

while [[ $# -gt 0 ]]; do
    arg="$1"
    shift

    case "$arg" in
      --cluster-name)
          CLUSTER_NAME=$(echo "$1" | tr '[:upper:]' '[:lower:]') # Convert to lower case

          # Preflight checks
          if [ ! -d "$CLUSTER" ]; then
              echo "You want to create the $CLUSTER cluster, but I do not see a directory containing the necessary config files"
              exit 1
          fi

          shift
          ;;
      --recovery)
          RECOVERY=true
          ;;
      --private-key-path)
          if $RECOVERY; then
              if [ -d "$1" ]; then
                PRIVATE_KEY_PATH=$1
              else
                echo "private key path does not exist at the given location $1"
              fi
          else
              echo "Specified private keys dir, but this is not recovery mode!"
              exit 1
          fi
          shift
          ;;
      --public-key-path)
          if $RECOVERY; then
              if [ -d "$1" ]; then
                PUBLIC_KEY_PATH=$1
              else
                echo "public key dir does not exist at the given location $1"
              fi
          else
              echo "Specified public keys dir, but this is not recovery mode!"
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
      --preflight-check)
          PREFLIGHT_CHECK=$1
          shift
          ;;
      --generate-argocd-password)
          GENERATE_ARGOCD_PASSWORD=$1
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

if $PREFLIGHT_CHECK; then
    # Preflight checks
    for program in kubectl kubeseal helm bcrypt-tool pwgen yq
    do
        if ! command -v "$program" >/dev/null; then
            DEPFAIL $program
        fi
    done

    for folder in argocd-application-templates argocd-clusters-managed sealed-secrets
    do
        if [ ! -d "./$folder" ]; then
            CWDFAIL "$folder"
        fi
    done
fi


if [ -z "$SETTINGS_FILE" ]; then
  echo "Missing required arguments"
  ARGFAIL
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
REPO_URL=$(yq eval '.argo-cd.repo.url' "$SETTINGS_FILE")
OCI_URL=$(yq eval '.argo-cd.repo.oci' "$SETTINGS_FILE")
GIT_AUTH_TYPE=$(yq eval '.argo-cd.repo.auth.git' "$SETTINGS_FILE")
GIT_AUTH_URL=$(yq eval '.argo-cd.repo.auth.url' "$SETTINGS_FILE")
ARGOCD_SECRET_NAME=argocd-"$CLUSTER_NAME"-admin

if $INSTALL_K8S; then
    case "$K8S_TYPE" in
      bare)
        echo "We expect you have setup the k8s by yourself (kubeadm) or via puppet on bare metal node"
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

##### Recovery mode checks #####
# Cancel if not recovery mode and cluster folder exists or if in recovery mode and some manifests are missing
if $RECOVERY; then
    echo "Using recovery mode: Existing manifests will be used."
    for required_folder in \
        "./argocd-clusters-managed/${CLUSTER_NAME}" \
        "./argocd-clusters-managed/${CLUSTER_NAME}/templates" \
        "./sealed-secrets/${CLUSTER_NAME}" \
        "$PRIVATE_KEY_PATH" \
        "$PUBLIC_KEY_PATH"
    do
        if [[ ! -d "$required_folder" ]]; then
            echo "ERROR in recovery mode, missing $required_folder"
            echo "You must run recovery mode in an argocd-apps branch where this cluster was installed successfully once"
            CANCEL_INSTALL
        fi
    done

    for required_file in \
        "./argocd-clusters-managed/${CLUSTER_NAME}/Chart.yaml" \
        "./argocd-clusters-managed/${CLUSTER_NAME}/templates/root.yaml"
    do
        if [ ! -f "$required_file" ]; then
            echo "ERROR in recovery mode, missing $required_file"
            echo "you must run recovery mode in an argocd-apps branch where this cluster was installed successfully once"
            CANCEL_INSTALL
        fi
    done
fi

export HELM_EXPERIMENTAL_OCI=1

##### Install sealed secrets #####
if $SETUP_SEALED_SECRET; then

    mkdir -p ./argocd-clusters-managed/"$CLUSTER_NAME"
    mkdir -p ./argocd-clusters-managed/"$CLUSTER_NAME"/templates

    # Create system namespace if it doesnt exist
    if ! kubectl get namespaces system &>/dev/null; then
        HEAD "Creating system namespace...        "
        kubectl create namespace system &>>/tmp/argocd.log
        STAT $?
    fi

    if $RECOVERY; then
        # Import old sealed-secrets private keys
        for keypath in "$PRIVATE_KEY_PATH"/*.key; do
            secret_name=$(basename "${keypath%.*}")
            if ! kubectl get secret -n system "$secret_name" -o name | grep "$secret_name" >/dev/null; then
                kubectl -n system create secret tls "$secret_name" --cert="${PUBLIC_KEY_PATH}/${secret_name}.crt" --key="$keypath" &>>/tmp/argocd.log
                kubectl -n system label secret "$secret_name" sealedsecrets.bitnami.com/sealed-secrets-key=active &>>/tmp/argocd.log
            fi
        done
    fi

    # Switch local helm chart to use upstream repo instead of OCI cache
    if ! helm list --deployed -n system -q | grep sealed-secrets >/dev/null; then
        yq eval -i '.dependencies.[].repository = "https://bitnami-labs.github.io/sealed-secrets"' ./argocd-helm-charts/sealed-secrets/Chart.yaml

        HEAD "Installing sealed-secrets... "
        helm dep update ./argocd-helm-charts/sealed-secrets &>>/tmp/argocd.log

        cp ./argocd-application-templates/sealed-secrets.yaml ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/sealed-secrets.yaml

        yq eval --inplace ".spec.source.repoURL = \"$REPO_URL\"" ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/sealed-secrets.yaml
        yq eval --inplace ".spec.source.helm.valueFiles.[1] = \"../../argocd-clusters-managed/$CLUSTER_NAME/values-sealed-secrets.yaml\"" ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/sealed-secrets.yaml

        helm install --namespace system sealed-secrets argocd-helm-charts/sealed-secrets &>>/tmp/argocd.log

        STAT $?
    else
        HEAD "sealed-secrets is already installed... "
        STAT $?
    fi

    # Create required directory
    mkdir -p ./sealed-secrets/"$CLUSTER_NAME"
    mkdir -p ./sealed-secrets/"$CLUSTER_NAME"/argocd

    #### BUG #####
    ## As per plan we need to have a single repo for all customer to manage the argocd-helm-charts
    ## but every customer will have their own OCI repo, so not sure how to do deal with that
    ## leaving it for now

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

    mkdir -p ./argocd-clusters-managed/"$CLUSTER_NAME"
    mkdir -p ./argocd-clusters-managed/"$CLUSTER_NAME"/templates

    ### Need to add steps, if we are recovering argocd ####
    if ! kubectl get namespaces argocd &>/dev/null; then
        HEAD "Creating argocd namespace...        "
        kubectl create namespace argocd &>>/tmp/argocd.log
        STAT $?
    fi

    kubectl get secret \
        --namespace system \
        -l sealedsecrets.bitnami.com/sealed-secrets-key=active \
        -o jsonpath='{'.items[0].data."tls\.crt"'}' \
        | base64 -d > "./sealed-secrets/$CLUSTER_NAME/$CLUSTER_NAME.pem"

    ARGOCD_CTRL_REPLICAS=$(DEFAULT_VALES '.argo-cd.controller.replicas' 1)
    ARGOCD_REPO_REPLICAS=$(DEFAULT_VALES '.argo-cd.repoServer.replicas' 1)
    ARGOCD_REPO_NAME=$(yq eval '.argo-cd.repo.name' "$SETTINGS_FILE")

    # This is the form in which argocd stores its admin password
    PASSWORD=$(pwgen -y 30 1)
    SECRET_KEY=$(pwgen 48 1)
    ENCODED_PASSWORD_HASH=$(bcrypt-tool hash "$PASSWORD" 10)

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
                    --from-literal=url="$REPO_URL" \
                    --from-literal=username="$HTTPS_USERNAME" \
                    --from-literal=password="$HTTPS_PASSWORD" \
                    --output yaml \
                    | yq eval '.metadata.labels.["argocd.argoproj.io/secret-type"]="repository"' - \
                    | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - \
                    | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - \
                    | kubeseal --controller-namespace system \
                    --controller-name sealed-secrets \
                    --cert ./sealed-secrets/"$CLUSTER_NAME"/"$CLUSTER_NAME".pem \
                    - > ./sealed-secrets/"$CLUSTER_NAME"/argocd/"$ARGOCD_SECRET_NAME".json
                STAT $?

                HEAD "Applying sealed-secrets for $ARGOCD_SECRET_NAME ...   "
                kubectl apply --namespace argocd -f ./sealed-secrets/"$CLUSTER_NAME"/argocd/"$ARGOCD_SECRET_NAME".json &>>/tmp/argocd.log
                kubectl get secret --namespace argocd "$ARGOCD_SECRET_NAME" >/dev/null
                STAT $?
            fi

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
                    --cert ./sealed-secrets/"$CLUSTER_NAME"/"$CLUSTER_NAME".pem \
                    - > ./sealed-secrets/"$CLUSTER_NAME"/argocd/argocd-secret.json
                STAT $?

                echo "Argocd password: $PASSWORD"

                HEAD "Applying sealed-secrets for argocd-secret...   "
                kubectl apply --namespace argocd -f ./sealed-secrets/"$CLUSTER_NAME"/argocd/argocd-secret.json &>>/tmp/argocd.log
                kubectl get secret --namespace argocd argocd-secret >/dev/null
                STAT $?
            fi

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
                    --cert ./sealed-secrets/"$CLUSTER_NAME"/"$CLUSTER_NAME".pem \
                    - > ./sealed-secrets/"$CLUSTER_NAME"/argocd/"$ARGOCD_SECRET_NAME".json
                STAT $?

                HEAD "Applying sealed-secrets for $ARGOCD_SECRET_NAME ...   "
                kubectl apply --namespace argocd -f ./sealed-secrets/"$CLUSTER_NAME"/argocd/"$ARGOCD_SECRET_NAME".json &>>/tmp/argocd.log
                kubectl get secret --namespace argocd "$ARGOCD_SECRET_NAME" >/dev/null
                STAT $?
            fi

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
                    --cert ./sealed-secrets/"$CLUSTER_NAME"/"$CLUSTER_NAME".pem \
                    - > ./sealed-secrets/"$CLUSTER_NAME"/argocd/argocd-secret.json
                STAT $?

                echo "Argocd password: $PASSWORD"

                HEAD "Applying sealed-secrets for argocd-secret...   "
                kubectl apply --namespace argocd -f ./sealed-secrets/"$CLUSTER_NAME"/argocd/argocd-secret.json &>>/tmp/argocd.log
                kubectl get secret --namespace argocd argocd-secret >/dev/null
                STAT $?
            fi

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

    if [ -n "$OCI_URL" ] && ! kubectl get secrets -n argocd helm-repos-cache -o name &>/dev/null; then
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
            --cert ./sealed-secrets/"$CLUSTER_NAME"/"$CLUSTER_NAME".pem \
            - > ./sealed-secrets/"$CLUSTER_NAME"/argocd/helm-repos-cache.json
        STAT $?

        HEAD "Applying sealed-secrets for OCI repo...   "
        kubectl apply --namespace argocd -f ./sealed-secrets/"$CLUSTER_NAME"/argocd/helm-repos-cache.json &>>/tmp/argocd.log
        kubectl get secret --namespace argocd helm-repos-cache >/dev/null
        STAT $?
    fi

    if ! helm list --deployed -n argocd -q | grep argo-cd >/dev/null; then
        yq eval -i '.dependencies.[].repository = "https://argoproj.github.io/argo-helm"' ./argocd-helm-charts/argo-cd/Chart.yaml

        HEAD "Installing argocd...         "
        helm dep update ./argocd-helm-charts/argo-cd &>> /tmp/argocd.log

        cp ./argocd-application-templates/argo-cd.yaml ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/argo-cd.yaml

        yq eval --inplace ".spec.source.repoURL = \"$REPO_URL\"" ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/argo-cd.yaml
        yq eval --inplace ".spec.source.helm.valueFiles.[1] = \"../../argocd-clusters-managed/$CLUSTER_NAME/values-argo-cd.yaml\"" ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/argo-cd.yaml

        # We want to setup the secret via sealed-secret, so we should make it default to false
        # so argocd does not create argocd-secret and we create it ourselves.
        helm install \
            --namespace argocd \
            --set argo-cd.configs.secret.createSecret=false \
            --set argo-cd.controller.replicas="$ARGOCD_CTRL_REPLICAS" \
            --set argo-cd.repoServer.replicas="$ARGOCD_REPO_REPLICAS" \
            argo-cd ./argocd-helm-charts/argo-cd &>> /tmp/argocd.log

        # we can do the same with sed, but going ahead with yq
        #sed -i "s/<cluster_name>/$CLUSTER_NAME/g" argocd-application-templates/argo-cd.yaml
        STAT $?
    else
        HEAD "argocd is already installed... "
        STAT $?
    fi

    # Switch to the original state of the file, after installing
    git restore ./argocd-helm-charts/argo-cd/Chart.yaml

    rm -fr "./sealed-secrets/$CLUSTER_NAME/$CLUSTER_NAME.pem"
fi

##### Install root app #####
if $SETUP_ROOT_APP; then
    if ! $RECOVERY; then
        HEAD "Writing root app manifests..."
        mkdir -p ./argocd-clusters-managed/"$CLUSTER_NAME"
        mkdir -p ./argocd-clusters-managed/"$CLUSTER_NAME"/templates

        cp ./argocd-application-templates/Chart.yaml ./argocd-clusters-managed/"$CLUSTER_NAME"/Chart.yaml
        cp ./argocd-application-templates/root.yaml ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/root.yaml

        # Edit the yaml in place with required settings
        yq eval --inplace ".spec.source.path = \"argocd-clusters-managed/$CLUSTER_NAME\"" ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/root.yaml
        yq eval --inplace ".spec.source.repoURL = \"$REPO_URL\"" ./argocd-clusters-managed/"$CLUSTER_NAME"/templates/root.yaml

        STAT $?
    fi

    HEAD "Installing root app...       "
    helm template ./argocd-clusters-managed/"$CLUSTER_NAME" --show-only templates/root.yaml | kubectl apply -f - &>>/tmp/argocd.log
    STAT $?
fi

## Let's delete the initial-admin-secret secret, so we can have the one we want.
if kubectl get secret -n argocd argocd-initial-admin-secret -o name &>/dev/null; then
    kubectl -n argocd delete secret/argocd-initial-admin-secret &>>/tmp/argocd.log
fi

rm -fr "./sealed-secrets/$CLUSTER_NAME/$CLUSTER_NAME.pem"

echo "Installation finished"
