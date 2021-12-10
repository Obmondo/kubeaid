#!/usr/bin/env bash

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -euo pipefail

if [ ! -e "clusters/${1}-vars.jsonnet" ]
then
    echo "no such variable file ${1}.jsonnet"
    exit 1
fi

#initially remove the jsonnetfile.json and jsonnetfile.lock.json  
rm jsonnetfile.json
rm jsonnetfile.lock.json

case ${1} in

  htzfsn1-kam)
    echo -n "using @release-0.8 for htzfsn1-kam"
    jb init
    jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@release-0.8
    ;;

  htzhel1-kbm)
    echo -n "i @release-0.9 release for htzhel1-kbm"
    jb init
    jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@release-0.9
    ;;
esac


# Make sure to use project tooling
PATH="$(pwd)/tmp/bin:${PATH}"
OUTDIR=$(basename ${1})

# Make sure to start with a clean 'manifests' dir
rm -rf $OUTDIR
mkdir -p $OUTDIR/setup

# Calling gojsontoyaml is optional, but we would like to generate yaml, not json
#jsonnet -J vendor -m manifests "${1-example.jsonnet}" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}

jsonnet -J vendor --ext-code-file vars="clusters/${1}-vars.jsonnet" -m $OUTDIR "common-template.jsonnet" | xargs -I{} sh -c 'cat {} | $(go env GOPATH)/bin/gojsontoyaml > {}.yaml; rm -f {}' -- {}

# Make sure to remove json files
find $OUTDIR -type f ! -name '*.yaml' -delete
rm -f kustomization
