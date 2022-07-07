#!/bin/bash

set -x
set -eou pipefail

HELM_APP="${1:-argocd-helm-charts}"
MERGE_REQUEST="${2:-false}"

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
    if ! helm repo list -o yaml | yq eval -e ".[].name == \"$HELM_REPO_NAME\"" >/dev/null 2>/dev/null; then
      helm repo add "$HELM_REPO_NAME" "$HELM_REPOSITORY_URL" >/dev/null
    fi

    # Check if we have an upstream chart already present or not
    if test -f "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME/Chart.yaml"; then
      HELM_UPSTREAM_CHART_VERSION=$(helm search repo --regexp "${HELM_REPO_NAME}/${HELM_CHART_NAME}[^-]" --version ">=$HELM_CHART_VERSION" --output yaml | yq eval '.[].version' -)

      # Compare the version of upstream chart and our local chart
      # if there is difference, run helm dep up or else skip
      if [ "$HELM_UPSTREAM_CHART_VERSION" != "$HELM_CHART_VERSION" ]; then
        echo "HELMING $HELM_CHART_NAME"

        # Update the chart.yaml file
        yq eval -i ".dependencies[].version = \"$HELM_UPSTREAM_CHART_VERSION\"" "$HELM_CHART_YAML"

        # Go to helm chart, 1st layer
        helm dependencies update "$HELM_CHART_PATH"

        # Untar the tgz file
        tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_UPSTREAM_CHART_VERSION.tgz"

        # TODO: script does not support upstream chart dependency with file path
        # need to sort out this later, for now only rook-ceph is the only chart which has this issue.
        if ! grep -ir 'file://' "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME/Chart.yaml"; then

          # some chart has some dependencies, but those dependencies are removed from upstream repo
          # f.ex yetibot depends on postgresql on version 8.6.12 (but 8.6.12 is removed from bitnami helm chart repo)

          if [ "$HELM_REPO_NAME" == "yetibot" ] || [ "$HELM_REPO_NAME" == "keycloak" ]; then
            echo "Skipping $HELM_REPO_NAME helm dependency update, due to dependency being obsolete"
          else
            # Go to helm chart, 2nd layer
            helm dependencies update "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME"
          fi

        fi
      else
        echo "Helm chart $HELM_REPO_NAME matches with the version $HELM_CHART_VERSION given in $HELM_CHART_NAME/Chart.yaml"
      fi
    else
      echo "HELMING $HELM_CHART_NAME"
      # Go to helm chart, 1st layer
      helm dependencies update "$HELM_CHART_PATH"

      # Untar the tgz file
      tar -C "$HELM_CHART_DEP_PATH" -xvf "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME-$HELM_CHART_VERSION.tgz"

      # Go to helm chart, 2nd layer
      helm dependencies update "$HELM_CHART_DEP_PATH/$HELM_CHART_NAME"
    fi
  fi
}

function merge_request() {
  chart_name=$1

  # Don't run for merge requests that target a branch that is not master/main.
  #if [[ "${CI_COMMIT_REF_NAME}" != master ]] && [[ "${CI_COMMIT_REF_NAME}" != main ]]; then
   # exit
  #fi

  config_repo_path=$(pwd)
  deploy_target_branch="master"

  git config --global user.email "${GITLAB_USER_EMAIL}"
  git config --global user.name "${GITLAB_USER_NAME}"

  # Set the remote url
  git remote set-url origin "https://oauth2:${HELM_UPDATE_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}"

  # Check if we have modifications to commit
  CHANGES=$(git -C "${config_repo_path}" status --porcelain | wc -l)

  if (( CHANGES > 0)); then
    title="[CI] Helm Chart Update ${chart_name}"

    git switch --create "${chart_name}" --track "origin/${deploy_target_branch}"

    git -C "${config_repo_path}" status
    git -C "${config_repo_path}" commit -m "${title}"

    # shellcheck disable=SC2094
    output=$(2>&1 git -C "${config_repo_path}" push \
                  --force-with-lease \
                  -o merge_request.create \
                  -o merge_request.target="${deploy_target_branch}" \
                  -o merge_request.title="${title}" \
                  -o merge_request.remove_source_branch \
                  -o merge_request.description="Auto-generated pull request from Obmondo K8id CI, created from changes by ${GITLAB_USER_NAME} (${GITLAB_USER_EMAIL})." \
                  origin HEAD)
    echo "${output}"

    if grep -q WARNINGS <<< "${output}"; then
      exit 1
    fi
  fi
}

if "${CI}" ; then
  TEMPDIR=$(mktemp -d)

  # NOTE: git diff does not work, cause gitlab only checkout only one branch
  # so there is nothing to compare.
  git clone "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}" "${TEMPDIR}"

  cd "${TEMPDIR}"
fi


if [ "$HELM_APP" != "argocd-helm-charts" ]; then
  if test -d "$HELM_APP"; then
    update_helm_chart "$HELM_APP"
  else
    echo "Error: $HELM_APP does not exists, please check the path"
    usage
    exit 1
  fi
else
  find "$HELM_APP" -maxdepth 1 -mindepth 1 -type d | sort | while read -r path; do
    update_helm_chart "$path"

    chart_name=$(echo "$path" | cut -d '/' -f2)

    # Raise MR for each individual helm chart
    if $MERGE_REQUEST; then
      merge_request "$chart_name"
    fi
  done
fi

find . -name '*tgz*' -delete
