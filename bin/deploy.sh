#!/usr/bin/env bash

set -euo pipefail

# set cluster name and replace dashes with underscore, since they're not allowed
# in GitLab CI variable names
# cluster="${DEPLOY_CLUSTER_NAME/-/__}"
cluster=ENABLEIT_HTZFSN1__KAM
deploy_token_name="DEPLOY_TOKEN_${cluster}"
deploy_token="${!deploy_token_name}"
deploy_target_branch_name="DEPLOY_TARGET_BRANCH_${cluster}"
deploy_target_branch="${deploy_target_branch_name}"

upstream_repo_username=oauth2
upstream_repo='gitlab.enableit.dk/kubernetes/kubernetes-config-enableit.git'
upstream_repo_path="/tmp/${cluster}"

git clone "https://${upstream_repo_username}:${deploy_token}@${upstream_repo}" "${upstream_repo_path}"

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

  # Update the repository and make sure to skip the pipeline create for this commit
  # shellcheck disable=SC2094
  git -C "${upstream_repo_path}" push \
      -o ci.skip \
      -o merge_request.create \
      -o merge_request.target=<branch_name> \
      -o merge_request.merge_when_pipeline_succeeds \
      -o merge_request.remove_source_branch \
      -o merge_request.title="${TITLE}" \
      -o merge_request.description="Auto-generated pull request from Obmondo, created from changes by ${GITLAB_USER_NAME} (${GITLAB_USER_EMAIL})." \
       origin "${deploy_target_branch}"
fi
