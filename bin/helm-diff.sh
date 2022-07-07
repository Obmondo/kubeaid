#!/usr/bin/env bash

set -eou pipefail

TEMPDIR=$(mktemp -d)

# NOTE: git diff does not work, cause gitlab only checkout only one branch
# so there is nothing to compare.
git clone "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}" "${TEMPDIR}"

cd "${TEMPDIR}"

# SKIP if there is a lint commit message
COMMIT_COUNT=$(git log --oneline --format=%s --abbrev-commit "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" | wc -l)

LINT_COUNT=$(git log --oneline --format=%s --abbrev-commit "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" | grep lint -c)

function helm_diff() {
  diff=$1
  chart_name=$2

  helm template "$diff" -f "${diff}/values.yaml" > "/tmp/${chart_name}_master.yaml"

  # Move to the local branch
  git switch "$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME"

  helm template "$diff" -f "${diff}/values.yaml" > "/tmp/${chart_name}_local.yaml"

  any_diff=$(diff -u "/tmp/${chart_name}_master.yaml" "/tmp/${chart_name}_local.yaml")

  if [ -n "$any_diff" ]; then
    echo "Nice, there is a diff between changes"
    echo "$any_diff"
  else
    echo "There is no changes based on the changes, not good"
    exit 1
  fi
}

function helm_compile(){
  diff=$1
  chart_name=$2

  if helm template "$diff" -f "${diff}/values.yaml"; then
    echo "Nice, Helm template works with the given values files"
  else
    echo "Ouch!! Helm template fails, please run this command to verify locally first"
    echo "helm template $diff -f ${diff}/values.yaml"
    exit 1
  fi
}

# Only get the directory name of the chart
for diff in $(git diff "${CI_COMMIT_SHA}" --name-only | grep argocd-helm-charts | cut -d '/' -f 1,2 | sort | uniq); do

  chart_name=$(echo "$diff" | cut -d '/' -f2)
  if [ "$COMMIT_COUNT" -eq "$LINT_COUNT" ]; then
    helm_compile "$diff" "$chart_name"
  else
    helm_diff "$diff" "$chart_name"
  fi
done


