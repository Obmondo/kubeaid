#!/bin/bash


for program in helm tar
do
  if ! command -v "$program" >/dev/null; then
    echo "Missing $program"
    exit 1
  fi
done

if ! helm version --template='Version: {{.Version}}' | grep 'v3.8'; then
  echo "I'm expecting helm version be v3.8.x"
  exit 1
fi

cd ..

find argocd-helm-charts -maxdepth 1 -mindepth 1 -type d | while read -r path; do
  HELM_CHART_PATH="$path"
  HELM_CHART_YAML="$path/Chart.yaml"
  HELM_CHART_NAME=$(yq eval '.dependencies[].name' "$HELM_CHART_YAML")
  HELM_CHART_VERSION=$(yq eval '.dependencies[].version' "$HELM_CHART_YAML")

  HELM_CHART_DEP_PATH="$HELM_CHART_PATH/charts"
  #UPSTREAM_REPOSITORY=$(yq eval '.dependencies[].repository' "$HELM_CHART_YAML")

  # Go to helm chart, 1st layer
  helm dependencies update "$HELM_CHART_PATH"

  # Go to helm chart, 2nd layer
  tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

  # Remove the tar file, we dont need that.
  rm -fr "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

  # Go into 2nd layer
  helm dependencies update "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME"
done
