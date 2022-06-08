#! /usr/bin/env bash
set -euo pipefail

function usage {
  echo -n "
Usage $0:
  --terraform-output-file   cluser config path [directory which consists yaml files]
  --kops-spec-path          directory path to save the kops spec file
  -h | --help

Example:
# $0 --terraform-output-file ../kubernetes-config-hobii/k8s/k8s.staging.hobii-dev.com/terraform.output --kops-spec-path /tmp
"
}

if [ -z "$1" ]; then
  usage
  exit
fi

while [[ $# -gt 0 ]]; do
  arg="$1"
  shift

  case "$arg" in
    --terraform-output-file)

      if test -f $1; then
        TF_OUTPUT=$1
      else
        echo "File $1 is not present, please give correct path"
        exit 1
      fi

      shift
      ;;
    --kops-spec-path)

      if test -d $1; then
        KOPS_SPEC_PATH=$1
      else
        echo "Directory $1 does not exists, please create one"
        exit 1
      fi
      shift
      ;;
    -h|--help)
        usage
        exit
        ;;
    *)
        echo "Error: wrong argument given"
        usage
        exit 1
        ;;
  esac
done

if [[ -z "$TF_OUTPUT" ]]; then
  echo "Missing required arguments"
  usage
  exit 1
fi

# For version comparison
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

KOPS=$(kops version | cut -d ' ' -f 2)

if ! [ "$(version "$KOPS")" -ge "$(version "1.20")" ]; then
  echo "This script needs at least kops 1.20"
  exit
fi

CLUSTER_NAME=$(cat $TF_OUTPUT | jq -r .cluster_name.value)

KOPS_TEMPLATE() {
  TYPE=$1
  kops toolbox template                                         \
    --name ${CLUSTER_NAME}                                      \
    --values ${TF_OUTPUT}                                       \
    --template cluster-setup-files/kops/templates/${TYPE}.tpl   \
    --format-yaml                                               \
    > ${KOPS_SPEC_PATH}/${TYPE}.yaml
}

for i in "cluster" "master-ig" "nodes-ig" "bastion"; do
  KOPS_TEMPLATE $i
done

echo "Kops cluster spec file is saved at ${KOPS_SPEC_PATH}"
