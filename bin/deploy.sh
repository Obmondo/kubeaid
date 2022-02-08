#!/usr/bin/env bash

set -x
set -euo pipefail

if ! [[ "${KUBERNETES_CONFIG_REPO_URL}" && "${KUBERNETES_CONFIG_REPO_TOKEN}" ]]; then
  >&2 echo "Required variables are unset. Please check config file '${CONFIG}' and ensure it has keys for cluster '${cluster}'."
  exit 42
fi

case "${KUBERNETES_CONFIG_REPO_URL}" in
  *gitlab*)
    upstream_repo_username=oauth2
    upstream_repo_password="${KUBERNETES_CONFIG_REPO_TOKEN}"
    upstream_repo_auth="${upstream_repo_username}:${upstream_repo_password}"
    ;;
  *github*)
    upstream_repo_username="${KUBERNETES_CONFIG_REPO_TOKEN}"
    upstream_repo_password=''
    upstream_repo_auth="${upstream_repo_username}"
esac

if ! [[ "${upstream_repo_auth}" ]]; then
  >&2 echo "Missing repo access token"
  exit 43
fi

if ! [[ "${KUBERNETES_CONFIG_REPO_URL}" =~ ^https://(.+) ]]; then
  >&2 echo "Unable to handle Kubernetes repo URL '${KUBERNETES_CONFIG_REPO_URL}'"
  exit 44
fi

deploy_target_branch="${OBMONDO_DEPLOY_TARGET_BRANCH:-main}"
upstream_repo="https://${upstream_repo_auth}@${BASH_REMATCH[1]}"
upstream_repo_path="/tmp/upstream"

git config --global user.email "${GITLAB_USER_EMAIL}"
git config --global user.name "${GITLAB_USER_NAME}"

git clone "${upstream_repo}" "${upstream_repo_path}"
git -C "${upstream_repo_path}" checkout -b "deploy-${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" --track "origin/${deploy_target_branch}"

# Loop over all clusters that are defined in upstream repo and copy
# corresponding compiled files into cloned repo.
find "${upstream_repo_path}" -mindepth 1 -maxdepth 1 -type d | while read -r cluster_dir; do
  cluster="$(basename "${cluster_dir}")"
  # FIXME: how do we do this properly?
  #
  # ./bin/build-jsonnet.sh "${cluster}"

  rsync -Pa "build/kube-prometheus/${cluster}/" "${cluster_dir}/"
  git -C "${upstream_repo_path}" add -f "${cluster}"
done

# Check if we have modifications to commit
CHANGES=$(git -C "${upstream_repo_path}" status --porcelain | wc -l)

if (( CHANGES > 0)); then
  title="${COMMIT_MESSAGE:-$CI_MERGE_REQUEST_TITLE}"

  git -C "${upstream_repo_path}" status
  git -C "${upstream_repo_path}" commit -m "${title}"

  # shellcheck disable=SC2094
  output=$(2>&1 git -C "${upstream_repo_path}" push \
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
