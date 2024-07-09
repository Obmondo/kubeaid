#!/bin/bash

set -eou pipefail

for program in helm tar yq git; do
  if ! command -v "$program" >/dev/null; then
    echo "Missing $program"
    exit 1
  fi
done

helm_version=$(helm version --template="{{.Version}}" | sed 's/[^[:alnum:]]\+//g; s/v//')

if [ ! "$helm_version" -ge "380" ] ; then
  echo "I'm expecting helm version to be greater than 3.8.0"
  exit 1
fi

function ARGFAIL() {
  echo -n "
Usage $0 [OPTIONS]:
  --update-helm-chart       Update specific helm chart  	  [Need path to specific helm chart]
  --update-all              Update all the helm chart   	  [Default: false]
  --pull-request            Raise Pull request         		  [Default: false] (Only in CI)
  --actions           	    Run inside a GitHub or Gitea Action   [Default: false] (Only in CI)
  --skip-charts             Skip updating certain charts 	  [Default: none]
  --chart-version           Helm chart version          	  [Default: latest]
  -h|--help

Example:
# $0 --update-helm-chart traefik
# $0 --update-all --skip-charts 'aws-efs-csi-driver,capi-cluster,grafana-operator,strimzi-kafka-operator'
"
}

declare UPDATE_ALL=false
declare PULL_REQUEST=false
declare ACTIONS=false
declare UPDATE_HELM_CHART=
declare SKIP_CHARTS=
declare ARGOCD_CHART_PATH="argocd-helm-charts"
declare CHART_VERSION=

[ $# -eq 0 ] && { ARGFAIL; exit 1; }

while [[ $# -gt 0 ]]; do
  arg="$1"
  shift

  case "$arg" in
    --update-all)
      UPDATE_ALL=true
      ;;
    --update-helm-chart)
      UPDATE_HELM_CHART=$1

      if ! test -d "$ARGOCD_CHART_PATH/$UPDATE_HELM_CHART"; then
        echo "Chart ${UPDATE_HELM_CHART} under $ARGOCD_CHART_PATH dir does not exist, please make sure directory exists."
        exit 1
      fi

      shift
      ;;
    --pull-request)
      PULL_REQUEST=true
      ;;
    --actions)
      ACTIONS=true
      ;;
    --skip-charts)
      SKIP_CHARTS=$1

      shift
      ;;
    --chart-version)
      CHART_VERSION=$1

      shift
      ;;
    -h|--help)
      ARGFAIL
      exit
      ;;
    *)
      echo "Error: wrong argument given"
      ARGFAIL
      exit 1
      ;;
  esac
done

# Build an array based on the input
IFS=',' read -ra SKIP_HELM_CHARTS <<< "$SKIP_CHARTS"

function update_helm_chart {
  HELM_CHART_PATH="$1"
  HELM_CHART_YAML="$1/Chart.yaml"
  CHART_VERSION=$2

  # Exit if no chart.yaml is present
  if ! test -f "$HELM_CHART_YAML"; then
    echo "No $HELM_CHART_YAML present, please fix it"
    exit 1
  fi

  HELM_REPO_NAME=$(yq eval '.name' "$HELM_CHART_YAML")
  HELM_CHART_DEP_PRESENT=$(yq eval '.dependencies | length' "$HELM_CHART_YAML")
  HELM_CHART_DEP_PATH="$HELM_CHART_PATH/charts"

  for SKIP_HELM_CHART in "${SKIP_HELM_CHARTS[@]}"; do
      if [ "$HELM_REPO_NAME" == "$SKIP_HELM_CHART" ]; then
          echo "Skipping $SKIP_HELM_CHART"
          return
      fi
  done

  # This chart does not have any dependencies, so lets not do helm dep up
  if [ "$HELM_CHART_DEP_PRESENT" -ne 0 ]; then
    # It support helm chart updation for multiple dependencies
    # Iterate over each dependency and extract the desired values
    for ((i = 0; i < HELM_CHART_DEP_PRESENT; i++)); do
        HELM_CHART_NAME=$(yq eval ".dependencies[$i].name" "$HELM_CHART_YAML")
        HELM_CHART_VERSION=$(yq eval ".dependencies[$i].version" "$HELM_CHART_YAML")
        HELM_REPOSITORY_URL=$(yq eval ".dependencies[$i].repository" "$HELM_CHART_YAML")

        # Add the repo
        if ! helm repo list -o yaml | yq eval -e ".[].name == \"$HELM_CHART_NAME\"" >/dev/null 2>/dev/null; then
          echo "ADD HELM CHARTS"
          helm repo add "$HELM_CHART_NAME" "$HELM_REPOSITORY_URL" >/dev/null
        fi

        # Check if we have an upstream chart already present or not
        if test -f "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME/Chart.yaml"; then
          if [ -z "$CHART_VERSION" ]; then
            HELM_UPSTREAM_CHART_VERSION=$(helm search repo --regexp "${HELM_CHART_NAME}/${HELM_CHART_NAME}[^-]" --version ">=$HELM_CHART_VERSION" --output yaml | yq eval '.[].version' -)
          else
            HELM_UPSTREAM_CHART_VERSION=$CHART_VERSION
          fi

          # Compare the version of upstream chart and our local chart
          # if there is difference, run helm dep up or else skip
          if [ "$HELM_UPSTREAM_CHART_VERSION" != "$HELM_CHART_VERSION" ]; then
            echo "HELMING $HELM_CHART_NAME"

            # Update the chart.yaml file
            yq eval -i ".dependencies[$i].version = \"$HELM_UPSTREAM_CHART_VERSION\"" "$HELM_CHART_YAML"

            # Go to helm chart, 1st layer
            helm dependencies update "$HELM_CHART_PATH"

            # Deleting old helm before untar
            echo "Deleting old $HELM_CHART_NAME before untar"
            rm -rf "${HELM_CHART_DEP_PATH:?}/${HELM_CHART_NAME}"

            # Untar the tgz file
            tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_UPSTREAM_CHART_VERSION.tgz"

            echo "[$(date +"%Y-%m-%d %H:%M:%S")] Updated $HELM_CHART_NAME from version $HELM_CHART_VERSION to $HELM_UPSTREAM_CHART_VERSION" >> changelog.md
          else
            echo "Helm chart $HELM_REPO_NAME is already on latest version $HELM_CHART_VERSION"
          fi
        else
          echo "HELMING $HELM_CHART_NAME"
          # Go to helm chart, 1st layer
          helm dependencies update "$HELM_CHART_PATH"

          # Deleting old helm before untar
          echo "Deleting old $HELM_CHART_NAME before untar"
          rm -rf "${HELM_CHART_DEP_PATH:?}/${HELM_CHART_NAME}"

          # Untar the tgz file
          tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

          echo "[$(date +"%Y-%m-%d %H:%M:%S")] Added $HELM_CHART_NAME version $HELM_CHART_VERSION" >> changelog.md
        fi
    done
  fi
}

function pull_request() {
  chart_name=$1

  config_repo_path=$(pwd)
  deploy_target_branch="master"

  # Check if we have modifications to commit
  CHANGES=$(git -C "${config_repo_path}" status --porcelain | wc -l)

  if (( CHANGES > 0 )); then
    title="[CI] Helm Chart Update ${chart_name}"

    git add "$ARGOCD_CHART_PATH/${chart_name}"
    git add changelog.md

    git -C "${config_repo_path}" commit -m "${title}"

    # Push changes to the remote repository
    git -C "${config_repo_path}" push origin HEAD

    export GITEA_TOKEN
    export GITHUB_TOKEN

    case "${KUBERNETES_CONFIG_REPO_URL}" in
      *gitea*)
        token=${GITEA_TOKEN}
        URL="gitea.obmondo.com"
        owner="EnableIT"
        repo="KubeAid"
        ;;
      *github*)
        token=${GITHUB_TOKEN}
        URL="api.github.com"
        owner="Obmondo"
        repo="kubeaid"
    esac

    # Create a pull request using the Gitea or GitHub API
    output=$(curl -X POST \
      -H "Authorization: token $token" \
      -d '{
        "title": "'"${title}"'",
        "head": "your_branch_with_changes",
        "base": "'"${deploy_target_branch}"'",
        "body": "Auto-generated pull request from Obmondo, created from changes by '"${USER_NAME}"' ('"${USER_EMAIL}"')."
      }' \
      "https://${URL}/repos/$owner/$repo/pulls")

    # Check for warnings or errors in the output and handle as needed
    if grep -q WARNINGS <<< "${output}"; then
      exit 1
    fi

    # Extract the pull request number from the output
    pull_request_number=$(echo "$output" | jq -r '.number')

    # Check the status of an Action workflow associated with the pull request
    workflow_status=$(curl -s -H "Authorization: token $token" \
      "https://${URL}/repos/$owner/$repo/actions/runs?event=workflow_dispatch" | \
      jq --arg pr "$pull_request_number" '.workflow_runs[] | select(.head_repository.owner.login == "'"$owner"'" and .head_repository.name == "'"$repo"'" and .pull_requests[0].number == $pr)')

    workflow_conclusion=$(echo "$workflow_status" | jq -r '.conclusion')

    # If the workflow has succeeded, pull the pull request
    if [ "$workflow_conclusion" == "success" ]; then
      pull_response=$(curl -s -X PUT -H "Authorization: token $token" \
        "https://${URL}/repos/$owner/$repo/pulls/$pull_request_number/pull")
      echo "Pull response: $pull_response"
    else
      echo "Workflow has not succeeded, skipping pull."
    fi

    # Delete the source branch after merging
    delete_branch_response=$(curl -X DELETE \
      -H "Authorization: token $token" \
      "https://${URL}/repos/OWNER/REPO_NAME/git/refs/heads/BRANCH_NAME")

    echo "$delete_branch_response"
  fi
}

if [ -n "$UPDATE_HELM_CHART" ]; then
  update_helm_chart "$ARGOCD_CHART_PATH/$UPDATE_HELM_CHART" "$CHART_VERSION"
fi

if "${ACTIONS}" ; then
  TEMPDIR=$(mktemp -d)

  case "${KUBERNETES_CONFIG_REPO_URL}" in
  *gitea*)
    token=${GITEA_TOKEN}
    git clone --depth 20 "https://oauth2:${token}@${URL}/${owner}/${repo}" "${TEMPDIR}"
    ;;
  *github*)
    git clone --depth 20 "https://${URL}/${owner}/${repo}" "${TEMPDIR}"
  esac

  git config --global user.email "${USER_EMAIL}"
  git config --global user.name "${USER_NAME}"

  cd "${TEMPDIR}"
fi

if "$UPDATE_ALL"; then
  find ./"$ARGOCD_CHART_PATH" -maxdepth 1 -mindepth 1 -type d | sort | while read -r path; do
    chart_name=$(basename "$path")

    unique_branch_id=$(echo $RANDOM | base64)
    git switch --create "${chart_name}_${unique_branch_id}" --track "origin/master"

    update_helm_chart "$path" "$CHART_VERSION"

    # Raise MR for each individual helm chart
    if $PULL_REQUEST; then
      pull_request "$chart_name"
    fi
  done
fi

find . -name '*.tgz' -delete
