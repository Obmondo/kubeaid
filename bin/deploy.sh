#!/usr/bin/env bash

set -x
set -euo pipefail

if ! [[ "${KUBERNETES_CONFIG_REPO_URL}" && "${KUBERNETES_CONFIG_REPO_TOKEN}" ]]; then
    >&2 echo "Required variables KUBERNETES_CONFIG_REPO_URL and KUBERNETES_CONFIG_REPO_TOKEN are unset.'."
  exit 42
fi

if ! [[ "${CI}" ]]; then
  >&2 echo "This script should only be run in a CI pipeline. This is not a CI pipeline."
  exit 41
fi

case "${KUBERNETES_CONFIG_REPO_URL}" in
  *gitlab*)
    config_repo_username=oauth2
    config_repo_password="${KUBERNETES_CONFIG_REPO_TOKEN}"
    config_repo_auth="${config_repo_username}:${config_repo_password}"
    ;;
  *github*)
    config_repo_username="${KUBERNETES_CONFIG_REPO_TOKEN}"
    config_repo_password=''
    config_repo_auth="${config_repo_username}"
esac

if ! [[ "${config_repo_auth}" ]]; then
  >&2 echo "Missing repo access token"
  exit 43
fi

if ! [[ "${KUBERNETES_CONFIG_REPO_URL}" =~ ^https://(.+) ]]; then
  >&2 echo "Unable to handle Kubernetes repo URL '${KUBERNETES_CONFIG_REPO_URL}'"
  exit 44
fi

config_repo_url_with_auth="https://${config_repo_auth}@${KUBERNETES_CONFIG_REPO_URL:8}"
deploy_target_branch="${OBMONDO_DEPLOY_TARGET_BRANCH:-main}"
config_repo_name=$(echo "$KUBERNETES_CONFIG_REPO_URL" | sed -r "s/.+\/(.+)\..+/\1/")
config_repo_path="/tmp/${config_repo_name}"

git config --global user.email "${GITLAB_USER_EMAIL}"
git config --global user.name "${GITLAB_USER_NAME}"

git clone "${config_repo_url_with_auth}" "${config_repo_path}"
git -C "${config_repo_path}" checkout -b "deploy-${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" --track "origin/${deploy_target_branch}"

# Loop over all clusters that are defined in config repo and copy
# corresponding compiled files into cloned repo.
find "${config_repo_path}/k8s/" -mindepth 1 -maxdepth 1 -type d -not -name .\* | while read -r cluster_dir; do
    ./build/kube-prometheus/build.sh "$cluster_dir"
    git -C "${config_repo_path}" add -f "${cluster_dir}"
done

# Check if we have modifications to commit
CHANGES=$(git -C "${config_repo_path}" status --porcelain | wc -l)

if (( CHANGES > 0)); then
  title='Updated Prometheus builds'

  git -C "${config_repo_path}" status
  git -C "${config_repo_path}" commit -m "${title}"

  # shellcheck disable=SC2094
  output=$(2>&1 git -C "${config_repo_path}" push \
                --force-with-lease \
                -o merge_request.create \
                -o merge_request.target="${deploy_target_branch}" \
                -o merge_request.title="${title}" \
                -o merge_request.merge_when_pipeline_succeeds \
                -o merge_request.remove_source_branch \
                -o merge_request.description="Auto-generated pull request from Obmondo, created from changes by ${GITLAB_USER_NAME} (${GITLAB_USER_EMAIL})." \
                origin HEAD)
  echo "${output}"

  if grep -q WARNINGS <<< "${output}"; then
    exit 1
  fi
fi
