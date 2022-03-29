#!/bin/bash

set -eou pipefail

HELM_APP="${1:-argocd-helm-charts}"

for program in helm tar; do
  if ! command -v "$program" >/dev/null; then
    echo "Missing $program"
    exit 1
  fi
done

if ! helm version --template='Version: {{.Version}}' | grep 'v3.8' >/dev/null; then
  echo "I'm expecting helm version be v3.8.x"
  exit 1
fi

function usage {
  echo -n "Usage:
$0 argocd-helm-charts/kube-iptables-tailer
or
$0
"
}

function update_helm_chart {
  HELM_CHART_PATH="$1"
  HELM_CHART_YAML="$1/Chart.yaml"

  # Exit if no chart.yaml is present
  if ! test -f "$HELM_CHART_YAML"; then
    echo "No $HELM_CHART_YAML present, please fix it"
    exit 1
  fi

  HELM_REPO_NAME=$(yq eval '.name' "$HELM_CHART_YAML")
  HELM_CHART_NAME=$(yq eval '.dependencies[].name' "$HELM_CHART_YAML")
  HELM_CHART_VERSION=$(yq eval '.dependencies[].version' "$HELM_CHART_YAML")
  HELM_CHART_DEP_PRESENT=$(yq eval '.dependencies | length' "$HELM_CHART_YAML")
  HELM_REPOSITORY_URL=$(yq eval '.dependencies[].repository' "$HELM_CHART_YAML")
  HELM_CHART_DEP_PATH="$HELM_CHART_PATH/charts"

  # This chart does not have any dependencies, so lets not do helm dep up
  if [ "$HELM_CHART_DEP_PRESENT" -ne 0 ]; then

    # Add the repo
    if ! helm repo list -o yaml | yq eval -e ".[].name == \"$HELM_REPO_NAME\"" >/dev/null; then
      helm repo add "$HELM_REPO_NAME" "$HELM_REPOSITORY_URL" >/dev/null
    fi

    # helm search repo whoami/whoami --output yaml | yq eval '.[].version' -

    # Check if we have an upstream chart already present or not
    if test -f "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME/Chart.yaml"; then
      HELM_UPSTREAM_APP_VERSION=$(yq eval '.version' "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME/Chart.yaml")

      # Compare the version of upstream chart and our local chart
      # if there is difference, run helm dep up or else skip
      if [ "$HELM_UPSTREAM_APP_VERSION" != "$HELM_CHART_VERSION" ]; then
        echo "HELMING $HELM_CHART_NAME"
        # Go to helm chart, 1st layer
        helm dependencies update "$HELM_CHART_PATH"

        # Untar the tgz file
        tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

        # Remove the tar file, we dont need that.
        rm -fr "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

        # Go to helm chart, 2nd layer
        helm dependencies update "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME"
      else
        echo "Helm chart $HELM_REPO_NAME matches with the version $HELM_CHART_VERSION given in Chart.yaml"

      fi
    else
      echo "HELMING $HELM_CHART_NAME"
      # Go to helm chart, 1st layer
      helm dependencies update "$HELM_CHART_PATH"

      # Untar the tgz file
      tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

      # Remove the tar file, we dont need that.
      rm -fr "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

      # Go to helm chart, 2nd layer
      helm dependencies update "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME"
    fi
  fi
}

if [ -n "$HELM_APP" ]; then
  if test -d "$HELM_APP"; then
    update_helm_chart "$HELM_APP"
  else
    echo "Error: $HELM_APP does not exists, please check the path"
    usage
    exit 1
  fi
else
  find "$HELM_APP" -maxdepth 1 -mindepth 1 -type d | while read -r path; do
    update_helm_chart $path
  done
fi
