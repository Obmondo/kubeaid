#!/bin/bash

# Documentation
# It will drop the yaml files into cluster-setup-scripts/puppet/<cluster-name>
# You will have to simply drop the yaml file and add any more extra keys
#
# Example
# ./cluster-setup-scripts/puppet/generate-puppet-hiera.sh \
#     --cluster-name kam.obmondo.com \
#     --version 1.22.5 \
#     --san-domains kam.obmondo.com,localhost,176.9.67.43,htzsb44fsn1a.enableit.dk:78.46.72.21,htzsb45fsn1a.enableit.dk:176.9.124.207,htzsb45fsn1b.enableit.dk:85.10.211.48

set -euo pipefail

for cmd in docker eyaml yq; do
  if ! command -v "$cmd" >/dev/null; then
    echo "$cmd is not installed, please install it"
  fi
done

ARGFAIL() {
    echo -n "
Usage $0 [OPTION]:
  --cluster-name                  full cluser-name                   [Required]
  --version                       kubernetes cluster version         [Required]
  --container                     which container type to use
                                  - docker
                                  - podman
                                  - containerd                       Default=docker
  --san-domains                   list of domains in etcd clusters   [Required]
  --kubetool-version              kubetool version                   Default=6.2.0
  --eyaml-public-key              eyaml public key path, expects it
                                  to be under cluster-setup-scripts/puppet Default=public_key.pkcs7.pem
  -h | --help

Example:
# $0 --name your-cluster-name
"
}

if [[ $# -eq 0 ]]; then
  ARGFAIL
  exit 0
fi

declare CONTAINER_RT=docker
declare KUBETOOL_VERSION=6.2.0
declare -a ETCD_CLUSTERS_IPS=()
declare EYAML_PUBLIC_KEY=public_key.pkcs7.pem

while [[ $# -gt 0 ]]; do
  arg="$1"
  shift

  case "$arg" in
  --cluster-name)
    CLUSTER_NAME=$(echo "$1" | tr '[:upper:]' '[:lower:]') # Convert to lower case

    shift
    ;;
  --version)
    VERSION=$1

    shift
    ;;
  --container)
    # docker and cri_containerd is supported.
    CONTAINER_RT=$1

    echo -n "You have given ${CONTAINER_RT}, but this only works with or
          you can tested with docker only.
          so defaulting to docker"
    shift
    ;;
  --san-domains)
    SAN_DOMAINS=$1

    shift
    ;;
  --kubetool-version)
    KUBETOOL_VERSION=$1

    shift
    ;;
  --eyaml-public-key)
    EYAML_PUBLIC_KEY=$1

    shift
    ;;
  -h|--help)
    ARGFAIL

    shit
    ;;
  esac
done

# If cluster name is not given in the args list, pick it up from the settings file
if [ -z "$CLUSTER_NAME" ]; then
  echo "no cluster name is given, please give one"
  exit 1
fi

if [ -z "$VERSION" ]; then
  echo -e "Need kubernetes version, can't proceed with that.
This scripts support kubernetes version 6.2.4"
  exit 1
fi

if [ -z "$SAN_DOMAINS" ]; then
  echo "NO san domains given, can't proceed with this."
  exit 1
else
  IFS="," read -r -a _SAN_DOMAINS <<< "${SAN_DOMAINS}"

  delim=""
  ETCD_INITIAL_CLUSTER=""
  for domain in "${_SAN_DOMAINS[@]}"; do
    if grep ':' <<< "$domain" >/dev/null; then
      ETCD_INITIAL_CLUSTER="$ETCD_INITIAL_CLUSTER$delim$domain"
      ETCD_CLUSTERS_IPS+=("$domain")
    else
      ETCD_INITIAL_CLUSTER="$ETCD_INITIAL_CLUSTER$delim$domain:$domain"
    fi
    delim=","
  done

  unset IFS
fi

# lets not accept etcd cluster nodes ip, its better to find out from the san-domains list
# if [ "${#ETCD_CLUSTERS_IPS[@]}" -eq 0 ]; then
#   if [ -z "$SAN_DOMAINS" ]; then
#     echo -e "Error: can not proceed without --etcd-cluters-ips or --san-domains
# Need atleast one of the options"
#     exit 1
#   fi
# else
#   echo -e "************* NOTE *****************
# You have not given --etcd-cluters-ips argument to the script. This script will try to identify the etcd cluster ips from the given --san-domains arguments
# These are the below etcd clusters ip and their FQDN
# If you believe this is wrong, better give the --etcd-cluters-ips options"
#   echo "${ETCD_CLUSTERS_IPS[@]}"
#
#   read -r -p "Type true or false: " CONFIRMATION
#
#   case $CONFIRMATION in
#     true)
#       echo "Going ahead with the identified etcd clusters ips"
#       ;;
#     false|*)
#       echo "Great, you don't trust the given etcd clusters ips, exiting"
#       exit 1
#       ;;
#   esac
# fi

cd "$(pwd)/cluster-setup-scripts/puppet"

echo -e "OS=debian
INSTALL_DASHBOARD=true
CNI_PROVIDER=calico
ETCD_INITIAL_CLUSTER=${ETCD_INITIAL_CLUSTER}
ETCD_IP=\"%{networking.ip}\"
KUBE_API_ADVERTISE_ADDRESS=\"%{networking.ip}\"
VERSION=${VERSION}
CONTAINER_RUNTIME=${CONTAINER_RT}" > "${CLUSTER_NAME}"_kubetool_setup_env


#echo "$ETCD_CLUSTERS_IPS"
# Create the required directory
mkdir -p "$(pwd)/${CLUSTER_NAME}"

# Generate the k8s hiera yaml files
docker run --rm -v "$(pwd)/${CLUSTER_NAME}":/mnt --env-file "${CLUSTER_NAME}"_kubetool_setup_env puppet/kubetool:"${KUBETOOL_VERSION}"


# NOTE
# docker generate the yaml file with root perms
sudo chown -R "$USER:$USER" "$(pwd)/${CLUSTER_NAME}"

# Encrypt the keys
#cat htzsb45fsn1a.enableit.dk.yaml | yq eval '."kubernetes::etcdclient_key"' - | eyaml encrypt --stdin --output=block --pkcs7-public-key=../public_key.pkcs7.pem -
for ETCD_NODE in "${ETCD_CLUSTERS_IPS[@]}"; do
  NODE_FILENAME=$(echo "${ETCD_NODE}" | cut -d ':' -f1)

  # Need to encrypt these keys from the nodes file
  # kubernetes::etcdserver_key
  # kubernetes::etcdpeer_key
  # kubernetes::etcdclient_key

  for NODE_KEYS in etcdserver_key etcdpeer_key etcdclient_key; do
    _NODE_KEYS=$(yq eval ".\"kubernetes::${NODE_KEYS}\"" "$(pwd)/${CLUSTER_NAME}/${NODE_FILENAME}".yaml \
                  | eyaml encrypt \
                  --stdin --output=string \
                  --pkcs7-public-key="${EYAML_PUBLIC_KEY}" -)

    yq eval --inplace ".\"kubernetes::${NODE_KEYS}\" = \"${_NODE_KEYS}\"" "$(pwd)/${CLUSTER_NAME}/${NODE_FILENAME}".yaml
  done

done

# NOTE
# We are removing etcdclient_crt and etcdclient_key from the hiera
# since its not getting used anywhere and when looked into cert, no details as well
#        Issuer: CN = etcd
#        Validity
#            Not Before: Dec 22 21:50:00 2021 GMT
#            Not After : Dec 21 21:50:00 2026 GMT
#        Subject: CN = client

yq eval --inplace "del(.\"kubernetes::etcdclient_key\")" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml
yq eval --inplace "del(.\"kubernetes::etcdclient_crt\")" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml

# Let's encrypt the Debian.yaml private keys
# Need to encrypt these keys from the OS family file
# kubernetes::etcd_ca_key
# kubernetes::kubernetes_ca_key
# kubernetes::discovery_token_hash
# kubernetes::kubernetes_front_proxy_ca_key
# kubernetes::sa_key
for OSFAMILY_KEYS in etcd_ca_key kubernetes_ca_key discovery_token_hash kubernetes_front_proxy_ca_key sa_key; do
  _OSFAMILY_KEYS=$(yq eval ".\"kubernetes::${OSFAMILY_KEYS}\"" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml \
                  | eyaml encrypt \
                  --stdin --output=string \
                  --pkcs7-public-key="${EYAML_PUBLIC_KEY}" -)

  yq eval --inplace ".\"kubernetes::${OSFAMILY_KEYS}\" = \"${_OSFAMILY_KEYS}\"" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml
done

# Delete the peer list, so we can only required one which are actual etcd nodes.
yq eval --inplace "del(.\"kubernetes::etcd_peers\")" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml

# Let's encrypt the few bad keys which comes from the kubetool command.
ETCD_CLUSTER_NODES=""
delim=""
for IPS in "${ETCD_CLUSTERS_IPS[@]}"; do
  _HOSTNAME=$(cut -d ':' -f 1 <<< "${IPS}")
  NODE_IP=$(cut -d ':' -f 2 <<< "${IPS}")
  ETCD_CLUSTER_NODES="$ETCD_CLUSTER_NODES$delim${_HOSTNAME}=https://${NODE_IP}:2380"
  delim=","

  # Fix the peers list
  yq eval --inplace ".\"kubernetes::etcd_peers\" += [\"${NODE_IP}\"]" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml
done

# Fix the initial_cluster setting
yq eval --inplace ".\"kubernetes::etcd_initial_cluster\" = \"${ETCD_CLUSTER_NODES}\"" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml

# Let's fix the calico version as well

# NOTE
# We are using 3.18 for now, since this is what we having been using and dont want any surprises.
yq eval --inplace ".\"kubernetes::cni_network_provider\" = \"https://docs.projectcalico.org/v3.18/manifests/calico.yaml\"" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml

# Fix the controller address
# NOTE
# We expect the cluster-name is a domain which can resolve.
yq eval --inplace ".\"kubernetes::controller_address\" = \"${CLUSTER_NAME}:6443\"" "$(pwd)/${CLUSTER_NAME}"/Debian.yaml

# lets change all the keys
grep -l '^kubernetes::' "$(pwd)/${CLUSTER_NAME}"/* | xargs sed -i 's/kubernetes/role::virtualization::kubernetes/g'
