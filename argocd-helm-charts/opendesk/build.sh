#!/usr/bin/env bash
#

# This script requires path to cluster folder in clone of customers
# kubernetes-config repo in arg $1	
# And it must be run from the root of the argocd-apps repo. Example:
# ./build/kube-prometheus/build.sh ../kubernetes-config-enableit/k8s/kam.obmondo.com

set -euo pipefail

# Check for input argument
if [[ -z "$1" ]]; then
  echo "Usage: $0 <target-directory>"
  exit 1
fi

# Check for input argument
if [[ -z "$2" ]]; then
  echo "Usage: $0 values"
  exit 1
fi

# Assign input argument to a variable
VALUES_FILE="$1"
KUBEAID_CONFIG="$2"

# Define download URL and file name
ZIP_URL="https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/archive/v1.6.0/opendesk-v1.6.0.zip"
ZIP_FILE="opendesk-v1.6.0.zip"
TARGET_DIR=deps

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

echo "Downloading OpenDesk v1.6.0 from:"
echo "  $ZIP_URL"
curl -L --fail --silent --show-error -o "$ZIP_FILE" "$ZIP_URL"

echo "Download complete: $ZIP_FILE"

# Unzip into the target directory
echo "Unzipping into $TARGET_DIR..."
unzip -q "$ZIP_FILE" -d "$TARGET_DIR"

EXTRACTED_DIR=$(find "$TARGET_DIR" -maxdepth 1 -type d -name "opendesk-v1.6.0*" | head -n1)

cd "${EXTRACTED_DIR}"

helmfile template -e default -n opendesk --state-values-file "${VALUES_FILE}" > "${KUBEAID_CONFIG}/opendesk.yaml"
