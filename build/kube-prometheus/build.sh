#!/usr/bin/env bash
#
# This script uses arg $1 (name of *.jsonnet file to use) to generate the
# manifests/*.yaml files.

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

RELEASE=$(jsonnet "clusters/${1}-vars.jsonnet" | jq -r .kube_prometheus_version)
JSONNET_LIB_PATH="libraries/${RELEASE}/vendor"
if ! [ -e "${JSONNET_LIB_PATH}" ]; then
  if [[ -d "libraries/${RELEASE}" ]]; then
    echo 'Release dir exists; exiting'
    exit 1
  fi

  echo "INFO: '${JSONNET_LIB_PATH}' doesn't exist; executing jsonnet-bundler"
  jb init
  jb install "github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@${RELEASE}"
  mkdir "libraries/${RELEASE}"
  mv vendor "libraries/${RELEASE}/"
  mv jsonnetfile.json jsonnetfile.lock.json "libraries/${RELEASE}/"
fi

echo "INFO: compiling jsonnet files into '${OUTDIR}'"
# shellcheck disable=SC2016
jsonnet -J \
        "${JSONNET_LIB_PATH}" \
        --ext-code-file vars="clusters/${1}-vars.jsonnet" \
        -m "${OUTDIR}" \
        "common-template.jsonnet" |
  while read -r f; do
    "$(go env GOPATH)/bin/gojsontoyaml" < "${f}" > "${f}.yaml"
    rm "${f}"
  done
