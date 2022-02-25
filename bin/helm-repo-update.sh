#!/bin/bash

set -eou pipefail

for program in helm tar
do
  if ! command -v "$program" >/dev/null; then
    echo "Missing $program"
    exit 1
  fi
done

if ! helm version --template='Version: {{.Version}}' | grep 'v3.8' >/dev/null; then
  echo "I'm expecting helm version be v3.8.x"
  exit 1
fi

find argocd-helm-charts -maxdepth 1 -mindepth 1 -type d | while read -r path; do
  HELM_CHART_PATH="$path"
  HELM_CHART_YAML="$path/Chart.yaml"
  HELM_CHART_NAME=$(yq eval '.dependencies[].name' "$HELM_CHART_YAML")
  HELM_CHART_VERSION=$(yq eval '.dependencies[].version' "$HELM_CHART_YAML")
  HELM_CHART_DEP_PATH="$HELM_CHART_PATH/charts"

  HELM_REPO_NAME=$(yq eval '.name' "$HELM_CHART_YAML")
  HELM_REPOSITORY_URL=$(yq eval '.dependencies[].repository' "$HELM_CHART_YAML")

  # Add the repo
  if ! helm repo list -o yaml | yq eval -e ".[].name == \"$HELM_REPO_NAME\"" >/dev/null; then
    helm repo add "$HELM_REPO_NAME" "$HELM_REPOSITORY_URL" >/dev/null
  fi

  # TODO: compare version from upstream and local helm chart version
  # helm search repo whoami/whoami --output yaml | yq eval '.[].version' -

  # Go to helm chart, 1st layer
  helm dependencies update "$HELM_CHART_PATH"

  # Untar the tgz file
  tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

  # Remove the tar file, we dont need that.
  rm -fr "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

  # Go to helm chart, 2nd layer
  helm dependencies update "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME"
done
