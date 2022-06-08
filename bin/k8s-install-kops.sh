#! /usr/bin/env bash
set -euo pipefail

function usage {
  echo -n "
Usage $0:
  --cluster-config-path     cluser config path [directory which consists yaml files]
  --cluster-name            full cluster name
  --ignore-git-branch       look for kops file in any git branch [default to master/main branch]
  -h | --help

Example:
# $0 --name staging
"
}

if [ -z "$1" ]; then
  usage
  exit
fi

declare FULLNAME=
declare IGNORE_GIT_BRANCH=false

while [[ $# -gt 0 ]]; do
  arg="$1"
  shift

  case "$arg" in
    --cluster-config-path)
        CLUSTER_CONFIG_PATH=$1

        # Preflight checks
        if [ ! -d "$CLUSTER_CONFIG_PATH" ]; then
          echo "You want to create the $CLUSTER_CONFIG_PATH cluster, but I do not see a directory containing the necessary config files"
          exit 1
        fi

        shift
        ;;
    --cluster-name)
        FULLNAME=$1
        shift
        ;;
    --ignore-git-branch)
        IGNORE_GIT_BRANCH=$1
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

if [ -z $FULLNAME ]; then
  FULLNAME=$(cat ${CLUSTER_CONFIG_PATH}/cluster.yaml | yq .metadata.name)
fi

if [[ -z "$CLUSTER_CONFIG_PATH" ]]; then
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

# https://kops.sigs.k8s.io/advanced/download_config/#managing-instance-groups
if ! kops get cluster --name "$FULLNAME" >/dev/null; then
  echo "Creating $FULLNAME now with KOPS"

  if ! $IGNORE_GIT_BRANCH; then
    if git rev-parse --abbrev-ref HEAD | grep master; then
      echo "First make sure that the git repo is up to date"
      git pull
      # If the grep does not match, the script will stop
      git status | grep "Your branch is up to date with"
    else
      echo "You are not working on a master branch"
      echo "git checkout master"
      exit 1
    fi
  fi

  kops create -f "$CLUSTER_CONFIG_PATH"/cluster.yaml
  kops create -f "$CLUSTER_CONFIG_PATH"/master-ig.yaml
  kops create -f "$CLUSTER_CONFIG_PATH"/nodes-ig.yaml
  kops create -f "$CLUSTER_CONFIG_PATH"/bastion.yaml
  #kops create secret --name "$FULLNAME" sshpublickey admin -i "$CLUSTER_CONFIG_PATH"/kops.pub
  kops update cluster "$FULLNAME" --yes --admin=48h
else
  echo "Cluster $FULLNAME is already present, replacing the config with the local changes"

  kops replace -f "$CLUSTER_CONFIG_PATH"/cluster.yaml
  kops replace -f "$CLUSTER_CONFIG_PATH"/master-ig.yaml
  kops replace -f "$CLUSTER_CONFIG_PATH"/nodes-ig.yaml
  kops replace -f "$CLUSTER_CONFIG_PATH"/bastion.yaml
  if ! kops update cluster "$FULLNAME" 2>/dev/null | grep 'No changes'; then
    echo -n "if there is a change in the yaml file, you might have to run
      # kops update cluster --yes --admin
      # kops rolling-update --yes

      Manually just to avoid pushing unwanted changes to cluster"
  else
    echo "No changes in the local files, going ahead.."
  fi
fi

cat <<EOF
###################################################################
Steps to be done manually.

**** IMPORTAMT NOTICE *****
**Make sure the new CIDR is added into openvpn config under vpn.blackwoodseven.com**

1. Create AWS peering using https://vpn.blackwoodseven.com/ between 'Transit VPC' and '$FULLNAME'
2. Do git clone on 'iac_iam' and run 'terraform apply' (master branch only)

While you go ahead and do the above steps, I'll wait here and when you are done, enter 'yes'.
###################################################################
EOF

read -r -p "Enter 'yes' : " GO_VALIDATE

if [ "$GO_VALIDATE" == "yes" ]; then
  until kops validate cluster "$FULLNAME" --wait=5m; do
    echo "Seems like validation is failing, going to sleep for 30 seconds and try again"
    sleep 30
  done

  echo "The $FULLNAME k8s cluster is up and running now"
else
  echo "Can not validate $FULLNAME k8s cluster, I guess because you are not ready"
  echo "You can run this script again once you have done the required steps"
  exit 1
fi
