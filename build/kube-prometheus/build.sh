#!/usr/bin/env bash

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -euo pipefail

if [ ! -e "${1}.jsonnet" ]
then
    echo "no such file ${1}.jsonnet"
    exit 1
fi


# Make sure to use project tooling
PATH="$(pwd)/tmp/bin:${PATH}"
OUTDIR=$(basename ${1})

# Make sure to start with a clean 'manifests' dir
rm -rf $OUTDIR
mkdir -p $OUTDIR/setup

# Calling gojsontoyaml is optional, but we would like to generate yaml, not json
#jsonnet -J vendor -m manifests "${1-example.jsonnet}" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}

jsonnet -J vendor -m $OUTDIR "${1}.jsonnet" | xargs -I{} sh -c 'cat {} | $(go env GOPATH)/bin/gojsontoyaml > {}.yaml; rm -f {}' -- {}

# Make sure to remove json files
find $OUTDIR -type f ! -name '*.yaml' -delete
rm -f kustomization

