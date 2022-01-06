#!/usr/bin/env bash
set -x

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -euo pipefail

if [ ! -e "clusters/${1}-vars.jsonnet" ]
then
    echo "no such variable file ${1}.jsonnet"
    exit 1
fi

# Make sure to use project tooling
PATH="$(pwd)/tmp/bin:${PATH}"
OUTDIR=$(basename "${1}")

# Make sure to start with a clean 'manifests' dir
rm -rf "${OUTDIR:?}/"
mkdir -p "${OUTDIR}/setup"

# Calling gojsontoyaml is optional, but we would like to generate yaml, not json
#jsonnet -J vendor -m manifests "${1-example.jsonnet}" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}

JSONNET_LIB_PATH="libraries/$(jsonnet "clusters/${1}-vars.jsonnet" | jq -r .kube_prometheus_version)/vendor"
if [ ! -e "${JSONNET_LIB_PATH}" ]; then
    jb init
    jb install "github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@$(jsonnet "clusters/${1}-vars.jsonnet" | jq -r .kube_prometheus_version)"
fi

# shellcheck disable=SC2016
jsonnet -J \
        "${JSONNET_LIB_PATH}" \
        --ext-code-file vars="clusters/${1}-vars.jsonnet" \
        -m "${OUTDIR}" \
        "common-template.jsonnet" |
  xargs -I{} sh -c 'cat {} | $(go env GOPATH)/bin/gojsontoyaml > {}.yaml; rm -f {}' -- {}

# Make sure to remove json files
find "${OUTDIR}" -type f ! -name '*.yaml' -delete
rm -f kustomization
