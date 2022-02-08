#!/usr/bin/env bash

set -x
set -euo pipefail

CONFIG="$1"

# shellcheck disable=SC1090
. "${CONFIG}"

# FIXME: should loop over all clusters
DEPLOY_CLUSTER_NAME=htzfsn1-kam

# FIXME: cluster folder should contain customer-id
customer_id=enableit
# set cluster name and replace dashes with underscore, since they're not allowed
# in GitLab CI variable names
cluster_sanitized="${DEPLOY_CLUSTER_NAME/-/__}"
cluster="${customer_id^^}_${cluster_sanitized^^}"
deploy_token_variable="DEPLOY_TOKEN_${cluster}"
deploy_token="${!deploy_token_variable}"
deploy_target_branch_variable="DEPLOY_TARGET_BRANCH_${cluster}"
deploy_target_branch="${!deploy_target_branch_variable}"
deploy_target_platform_variable="DEPLOY_TARGET_PLATFORM_${cluster}"
deploy_target_platform="${!deploy_target_platform_variable}"

if ! [[ "${deploy_token}" || "${deploy_target_branch}" || "${deploy_target_platform}" ]]; then
  >&2 echo "Required variables are unset. Please check config file '${CONFIG}' and ensure it has keys for cluster '${cluster}'."
  exit 42
fi

upstream_repo_username=oauth2
upstream_repo='gitlab.enableit.dk/kubernetes/kubernetes-config-enableit.git'
upstream_repo_path="/tmp/${cluster}"

git clone "https://${upstream_repo_username}:${deploy_token}@${upstream_repo}" "${upstream_repo_path}"
git -C "${upstream_repo_path}" checkout -b "deploy-${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" --track "origin/${deploy_target_branch}"

# Set the displayed user with the commits that are about to be made
git config --global user.email "${GITLAB_USER_EMAIL}"
git config --global user.name "${GITLAB_USER_NAME}"

# FIXME: change the source path
rsync -Pa build/kube-prometheus/htzfsn1-kam "${upstream_repo_path}"

git -C "${upstream_repo_path}" add -f .

# Check if we have modifications to commit
CHANGES=$(git -C "${upstream_repo_path}" status --porcelain | wc -l)

TITLE="${COMMIT_MESSAGE:-$CI_MERGE_REQUEST_TITLE}"

if (( CHANGES > 0)); then
  git -C "${upstream_repo_path}" status
  git -C "${upstream_repo_path}" commit -m "${TITLE}"

  # shellcheck disable=SC2094
  output=$(2>&1 git -C "${upstream_repo_path}" push \
                --force-with-lease \
                -o merge_request.create \
                -o merge_request.target="${deploy_target_branch}" \
                -o merge_request.title="${TITLE}" \
                -o merge_request.merge_when_pipeline_succeeds \
                -o merge_request.remove_source_branch \
                -o merge_request.description="Auto-generated pull request from Obmondo, created from changes by ${GITLAB_USER_NAME} (${GITLAB_USER_EMAIL})." \
                origin HEAD)
  echo "${output}"

  if grep -q WARNINGS <<< "${output}"; then
    exit 1
  fi
fi
