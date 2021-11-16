#!/bin/bash
set -euo pipefail
# Install argocd with root app using kubectl current config
# IMPORTANT: Make sure your kubeconfig is set correctly
# Also this script must be run from the root of the argocd-apps repo

##### Prerequisite and argument checks #####
# This script requires: kubectl, kubeseal, helm, bcrypt-tool, pwgen
CANCEL_INSTALL() {
    echo "Canceling install"
    exit 1
}
DEPFAIL() {
    echo "ERROR missing dependency: $1"
    echo "See wiki/guides/kubernetes-desktop-setup.md for how to install it"
    CANCEL_INSTALL
}
for program in kubectl kubeseal helm bcrypt-tool pwgen yq
do
    if [ -z "$(which ${program})" ]; then
        DEPFAIL program
    fi
done

# The argocd namespace should not exist already
if [[ " $(kubectl get namespaces -o 'jsonpath={.items[*].metadata.name}') " =~ " argocd " ]]; then
    echo 'Error: argocd namespace already exists!'
    echo 'Please run the argocd-apps/bin/uninstall-argocd.sh first'
    echo 'Use --keep-files flag if you dont want it to remove your local files for the cluster'
    CANCEL_INSTALL
fi

# We should be in the root of the argocd-apps repo
CWDFAIL() {
    echo "ERROR missing folder: $1"
    echo "You must run this script in the root of the argocd-apps repo"
    CANCEL_INSTALL
}
for folder in argocd-application-templates argocd-clusters-managed sealed-secrets
do
    if [ ! -d "./$folder" ]; then
        CWDFAIL "$folder"
    fi
done

ARGFAIL() {
    echo "Usage $(basename "${0}")
Required: [ -n cluster_name ] [ -t argocd-apps-repo-token ]
Optional: [ -r is_recovery ]
Required if recovery: [ -k sealed-secrets-private-keys-dir ] [ -c sealed-secrets-public-keys-dir ]"
    CANCEL_INSTALL
}

# Print kubeconfig warning
echo "Installing argocd on the cluster in your current kubeconfig!"
echo "You better have switched to the right one!"

##### Status message functions #####
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

##### Get user inputs #####
repo_url=$(yq e '.repoUrl' ./customer-settings.yaml)
is_recovery=
private_keys_path=
public_keys_path=
while getopts ":n:t:rk:c:h" options; do
    case "${options}" in
        n)
            cluster_name="${OPTARG}"
            ;;
        t)
            token="${OPTARG}"
            ;;
        r)
            is_recovery=true
            ;;
        k)
            if [ -n "$is_recovery" ]; then
                private_keys_path="${OPTARG}"
            else
                echo "Specified private keys dir, but this is not recovery mode!"
                exit 1
            fi
            ;;
        c)
            if [ -n "$is_recovery" ]; then
                public_keys_path="${OPTARG}"
            else
                echo "Specified public keys dir, but this is not recovery mode!"
                exit 1
            fi
            ;;
        *)
            ARGFAIL
            ;;
    esac
done

##### Recovery mode checks #####
# Cancel if not recovery mode and cluster folder exists or if in recovery mode
# and some manifests are missing
if [ -z "$is_recovery" ]; then
    for folder_to_be_created in "./argocd-clusters-managed/$cluster_name" "./sealed-secrets/$cluster_name"
    do
        if [ -d "$folder_to_be_created" ]; then
        echo "ERROR $folder_to_be_created already exists and this is not recovery mode"
        echo "Run this script with -r if you want it to use existing manifests otherwise delete existing manifests with rm -r $folder_to_be_created"
        CANCEL_INSTALL
        fi
    done
else
    echo "Using recovery mode: Existing manifests will be used."
    if [ -z "$private_keys_path" ]; then
        echo "Missing private_keys_path"
        ARGFAIL
    fi
    if [ -z "$public_keys_path" ]; then
        echo "Missing public_keys_path"
        ARGFAIL
    fi
    for required_folder in "./argocd-clusters-managed/${cluster_name}" "./argocd-clusters-managed/${cluster_name}/templates" "./sealed-secrets/${cluster_name}" "$private_keys_path" "$public_keys_path"
    do
        if [[ ! -d "$required_folder" ]]; then
            echo "ERROR in recovery mode, missing $required_folder"
            echo "You must run recovery mode in an argocd-apps branch where this cluster was installed successfully once"
            CANCEL_INSTALL
        fi
    done
    for required_file in "./argocd-clusters-managed/${cluster_name}/Chart.yaml" "./argocd-clusters-managed/${cluster_name}/templates/root.yaml"
    do
        if [ ! -f "$required_file" ]; then
            echo "ERROR in recovery mode, missing $required_file"
            echo "you must run recovery mode in an argocd-apps branch where this cluster was installed successfully once"
            CANCEL_INSTALL
        fi
    done
fi

##### Create argocd namespace #####
HEAD "Creating argocd namespace...        "
kubectl create namespace argocd &>>/tmp/argocd.log
kubectl config set-context --current --namespace=argocd &>>/tmp/argocd.log
STAT $?

##### Install argocd #####
HEAD "Installing argocd...         "
helm dep update ./argocd-helm-charts/argo-cd &>> /tmp/argocd.log
helm install -n argocd argo-cd ./argocd-helm-charts/argo-cd &>> /tmp/argocd.log
STAT $?

##### Add argocd-apps repo #####
# Name of the secret with the argocd-apps repo token
github_secret_name=argocd-"$cluster_name"-github

HEAD "Adding argocd-apps repo...   "
{
    kubectl create secret generic "$github_secret_name" --from-literal=username='oauth2' --from-literal=type='git' --from-literal=url='https://gitlab.enableit.dk/kubernetes/argocd-apps.git' --from-literal=password="$token"
    kubectl annotate secret/"$github_secret_name" 'managed-by=argocd.argoproj.io'
    kubectl label secret/"$github_secret_name" 'argocd.argoproj.io/secret-type=repository'
} &>>/tmp/argocd.log
STAT $?

sleep 1s

##### Install root app #####
if [ -z "$is_recovery" ]; then
    HEAD "Writing root app manifests..."
    mkdir ./argocd-clusters-managed/"$cluster_name"
    mkdir ./argocd-clusters-managed/"$cluster_name"/templates
    cp ./argocd-application-templates/Chart.yaml ./argocd-clusters-managed/"$cluster_name"/Chart.yaml

    # Copy and modify root.yaml
    sed -e "s/<cluster_name>/$cluster_name/g" -e "s/<repo_url>/${repo_url//[\/]/\\/}/g" ./argocd-application-templates/root.yaml > ./argocd-clusters-managed/"$cluster_name"/templates/root.yaml
    STAT $?
fi
HEAD "Installing root app...       "
helm template ./argocd-clusters-managed/"$cluster_name" --show-only templates/root.yaml | kubectl apply -f - &>>/tmp/argocd.log
STAT $?

sleep 1s

##### Install sealed secrets #####
HEAD "Installing sealed-secrets... "
# Create system namespace if it doesnt exist
if [[ " $(kubectl get namespaces -o 'jsonpath={.items[*].metadata.name}') " =~ " system " ]]; then
    echo "system namespace already exists" &>>/tmp/argocd.log
else
    kubectl create namespace system &>>/tmp/argocd.log
fi

if [ -n "$is_recovery" ]; then
    # Import old sealed-secrets private keys
    for keypath in "$private_keys_path"/*.key; do
        secret_name=$(basename "${keypath%.*}")
        kubectl -n system create secret tls "$secret_name" --cert="${public_keys_path}/${secret_name}.crt" --key="$keypath" &>>/tmp/argocd.log
        kubectl -n system label secret "$secret_name" sealedsecrets.bitnami.com/sealed-secrets-key=active &>>/tmp/argocd.log
    done
fi

# Switch local helm chart to use upstream repo instead of OCI cache
sed -ri -e 's/#+(repository: https?:)/\1/g' -e 's/(repository: "oci)/#\1/g' -e 's/#+(source: https?:)/\1/g' ./argocd-helm-charts/sealed-secrets/Chart.yaml

helm dep update ./argocd-helm-charts/sealed-secrets &>>/tmp/argocd.log
helm template sealed-secrets argocd-helm-charts/sealed-secrets --values argocd-helm-charts/sealed-secrets/values.yaml | kubectl apply -f - &>>/tmp/argocd.log

# Wait for sealed-secrets pod to start
IS_READY=$(kubectl -n system get pods -l 'app.kubernetes.io/name=sealed-secrets' -o jsonpath="{..status.containerStatuses[0].ready}")
until [ "$IS_READY" = "true" ]; do
    echo "Waiting for sealed-secrets pod to start..." &>>/tmp/argocd.log
    sleep 1
    IS_READY=$(kubectl -n system get pods -l 'app.kubernetes.io/name=sealed-secrets' -o jsonpath="{..status.containerStatuses[0].ready}")
done
echo "sealed secrets is ready, getting pub key for cluster" &>>/tmp/argocd.log

#  Get public key
if [ -z "$is_recovery" ]; then
    mkdir ./sealed-secrets/"$cluster_name"
fi
kubectl -n system get secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active -o jsonpath='{'.items[0].data."tls\.crt"'}' | base64 -d > ./sealed-secrets/"$cluster_name"/"$cluster_name.pem"

# Switch back to OCI (so we dont push the local change by mistake)
sed -ri -e 's/#+(repository: "oci)/\1/g' -e 's/(repository: https?:)/#\1/g' -e 's/(source: https?:)/#\1/g' ./argocd-helm-charts/sealed-secrets/Chart.yaml
STAT $?

##### Put secrets in sealed secrets (or import old ones) #####
HEAD "Creating sealed secrets...   "
kubectl config set-context --current --namespace=argocd &>>/tmp/argocd.log

## argocd-apps repo access token
kubectl annotate secret/"$github_secret_name" 'sealedsecrets.bitnami.com/managed=true' &>>/tmp/argocd.log
if [ -z "$is_recovery" ]; then
    # Get secret json
    kubectl -n argocd get secret/"$github_secret_name" -o json | sed -e '/"creationTimestamp":/d' -e '/"resourceVersion":/d' -e '/"uid":/d' -e 's/"namespace": "argocd",/"namespace": "argocd"/g' > ./sealed-secrets/"$cluster_name"/unsealed-"$github_secret_name".json
    # Turn it into a sealed secret
    kubeseal --controller-namespace system --cert ./sealed-secrets/"$cluster_name"/"$cluster_name".pem < ./sealed-secrets/"$cluster_name"/unsealed-"$github_secret_name".json > ./sealed-secrets/"$cluster_name"/"$github_secret_name".json
fi
kubectl apply -f ./sealed-secrets/"$cluster_name"/"$github_secret_name".json &>>/tmp/argocd.log
if [ -z "$is_recovery" ]; then
    rm ./sealed-secrets/"$cluster_name"/unsealed-"$github_secret_name".json
fi

## argocd admin password
# make sure argocd-secret is in use, and managed by sealed-secrets
{
    kubectl -n argocd delete secret/argocd-initial-admin-secret
    kubectl -n argocd annotate secret/argocd-secret 'managed-by=argocd.argoproj.io'
    kubectl -n argocd annotate secret/argocd-secret 'sealedsecrets.bitnami.com/managed=true'
} &>>/tmp/argocd.log
if [ -z "$is_recovery" ]; then
    # This is the form in which argocd stores its admin password
    password=$(pwgen 30 1)
    encoded_password_hash=$(bcrypt-tool hash "$password" 10 | base64 -w 0)
    # Get secret json
    kubectl -n argocd get secret/argocd-secret -o json | sed -e '/"admin.password":/d' -e '/"data": {/a\
        "admin.password": "'"$encoded_password_hash"'",' -e '/"creationTimestamp":/d' -e '/"resourceVersion":/d' -e '/"uid":/d' -e 's/"namespace": "argocd",/"namespace": "argocd"/g' > ./sealed-secrets/"$cluster_name"/unsealed-argocd-secret.json
    # Turn it into a sealed secret
    kubeseal --controller-namespace system --cert ./sealed-secrets/"$cluster_name"/"$cluster_name".pem < ./sealed-secrets/"$cluster_name"/unsealed-argocd-secret.json > ./sealed-secrets/"$cluster_name"/argocd-secret.json
fi
kubectl apply -f ./sealed-secrets/"$cluster_name"/argocd-secret.json &>>/tmp/argocd.log
if [ -z "$is_recovery" ]; then
    rm ./sealed-secrets/"$cluster_name"/unsealed-argocd-secret.json
fi
STAT $?

echo "Installation finished"
if [ -z "$is_recovery" ]; then
    echo "Argocd admin password = $password"
fi
