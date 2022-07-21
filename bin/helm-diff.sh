#!/usr/bin/env bash

set -eou pipefail

TEMPDIR=$(mktemp -d)

# NOTE: git diff does not work, cause gitlab only checkout only one branch
# so there is nothing to compare.
git clone "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}" "${TEMPDIR}"

cd "${TEMPDIR}"

# SKIP diff check part IF MR conststs of ONLY commits with word 'lint' in them
COMMIT_MSG=$(git log --oneline --pretty=format:'%s' --abbrev-commit "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" argocd-helm-charts)

COMMIT_COUNT=$(echo "$COMMIT_MSG" | wc -l)
LINT_COUNT=$(echo "$COMMIT_MSG" | { grep '^lint' -c || true; } )
LINT_COUNT=$(echo "$COMMIT_MSG" | { grep '^doc' -c || true; } )

function helm_diff() {
  chart_path="argocd-helm-charts/${1}"
  chart_name="$1"

  # Move to the local branch
  git checkout "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"

  # if incase the target branch code has some bug
  helm template "$chart_path" -f "${chart_path}/values.yaml" > "/tmp/${chart_name}_master.yaml" || true

  # Move to the local branch
  git checkout "$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME"

  helm template "$chart_path" -f "${chart_path}/values.yaml" > "/tmp/${chart_name}_local.yaml"

  any_diff=$(diff -u "/tmp/${chart_name}_master.yaml" "/tmp/${chart_name}_local.yaml" || true )

  if diff -u "/tmp/${chart_name}_master.yaml" "/tmp/${chart_name}_local.yaml"; then
    echo "There is no changes based on the changes, not good"
    exit 1
  else
    echo "Nice, there is a diff between changes"
    echo "$any_diff"
  fi
}

function helm_compile() {
  chart_name="argocd-helm-charts/${1}"

  git checkout "$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME"

  if helm template "$chart_name" -f "${chart_name}/values.yaml"; then
    echo "Nice, Helm template works with the given values files"
  else
    echo "Ouch!! Helm template fails, please run this command to verify locally first"
    echo "helm template $chart_name -f ${chart_name}/values.yaml"
    exit 1
  fi
}

# Only get the directory name of the chart
git diff "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" --name-only | grep argocd-helm-charts | cut -d '/' -f 1,2 | sort | uniq | while read -r diff; do

  chart_name=$(echo "$diff" | cut -d '/' -f2)

  if [ "$COMMIT_COUNT" -eq "$LINT_COUNT" ]; then
    helm_compile "$chart_name"
  elif [ "$COMMIT_COUNT" -eq "$DOC_COUNT" ]; then
    helm_compile "$chart_name"
  else
    # Check if there is any changes are in chart.yaml/lock files for a particular helm chart
    if git diff "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}..origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}" --name-only | grep -e "argocd-helm-charts/${chart_name}" | grep -v 'Chart'; then

      # Check if we have a value file in master branch, incase its a new helm chart.
      if test -f "${diff}/values.yaml"; then
        helm_diff "$chart_name"
      else
        helm_compile "$chart_name"
      fi
    else
      # Run the compile test, if there is changes only in the Chart.yaml or Chart.lock files
      helm_compile "$chart_name"
    fi
  fi
done
