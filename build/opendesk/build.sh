#!/usr/bin/env bash
#

# This script requires path to cluster folder in clone of customers
# kubernetes-config repo in arg $2
# and values file in arg $1	
# And it must be run from the root of the argocd-apps repo. Example:
# ./build/opendesk/build.sh ../kubernetes-config-enableit/k8s/test.cluster.com/opendesk

set -euo pipefail

# Check for input argument
if [[ -z "$1" ]]; then
  echo "Usage: $0 <target-directory>"
  exit 1
fi

# Assign input argument to a variable
VALUES_FILE="$1/values.yaml"
KUBEAID_CONFIG="$1/helmfile/opendesk.yaml"

# Right now we only support v1.6.0 - later supports will be added soon
cd "versions/v1.6.0"

helmfile template -e default -n opendesk --state-values-file "${VALUES_FILE}" > "${KUBEAID_CONFIG}"
