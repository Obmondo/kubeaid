#!/bin/bash

# This script sets up a new version directory for jsonnet-bundler dependencies.
# It performs the following tasks:
# 1. Checks for correct usage and ensures the script is run from the correct (root of KubeAid repo) location.
# 2. Verifies that the 'jb' command (jsonnet-bundler) is installed.
# 3. Checks if a directory for the specified version already exists.
# 4. Creates the directory if it does not exist.
# 5. Initializes jsonnet-bundler and installs the required dependencies for the specified version.
# Usage: ./build/kube-prometheus/script.sh <version-tag>

set -euo pipefail

# Ensure correct usage
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version-tag>"
  exit 1
fi

# sanity checks
BUILDPATH=build/kube-prometheus/
if [ ! -e "$BUILDPATH" ]; then
    echo "I cannot find $BUILDPATH - this script MUST be run from root of git repo"
    exit 1
fi

# Check if 'jb' is installed
if ! command -v jb &> /dev/null; then
  echo "'jb' command not found. Please install jsonnet-bundler."
  exit 1
fi

VERSION=$1
INSTALLPATH="${BUILDPATH}/libraries/${VERSION}"

# Check if the version directory already exists
if [[ -e "$INSTALLPATH" ]]; then
    echo "Version $VERSION already exists. Exiting."
    exit 1
fi

# Create the new version directory
mkdir -p "$INSTALLPATH"

# Navigate to the new directory and initialize jb
cd "$INSTALLPATH" || { echo "Failed to change directory to $INSTALLPATH"; exit 1; }

# Initialize jsonnet-bundler and install dependencies
jb init
jb install "github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@${VERSION}"
jb install "github.com/bitnami-labs/sealed-secrets/contrib/prometheus-mixin@main"
jb install "github.com/ceph/ceph/monitoring/ceph-mixin@main"
jb install "gitlab.com/uneeq-oss/cert-manager-mixin@master"
jb install "github.com/grafana/jsonnet-libs/opensearch-mixin@master"

echo "Version ${VERSION} added successfully."
