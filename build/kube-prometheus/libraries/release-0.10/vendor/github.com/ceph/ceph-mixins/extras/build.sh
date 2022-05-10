#!/usr/bin/env bash

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -e
set -x
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail

# Make sure to start with a clean 'manifests' dir
rm -rf manifests
mkdir manifests

# optional, but we would like to generate yaml, not json
jsonnet -J vendor -m manifests "example.jsonnet" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml; rm -f {}' -- {}
jsonnet -J vendor -m manifests "example-external.jsonnet" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml; rm -f {}' -- {}
# Rename the output rule yaml files
mv manifests/prometheus-rules.yaml manifests/prometheus-ceph-rules.yaml
mv manifests/prometheus-rules-external.yaml manifests/prometheus-ceph-rules-external.yaml

