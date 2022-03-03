#!/bin/bash

set -euo pipefail

# sanity checks
BUILDPATH=build/kube-prometheus/
if [ ! -e $BUILDPATH ]; then
    echo "I cannot find $BUILDPATH - this script MUST be run from root of git repo"
    exit 1
fi

if ! tmp=$(jsonnet --version); then
  echo "missing the program 'jsonnet'"
  exit 2
fi
if ! [[ "${tmp}" =~ v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "unable to parse jsonnet version ('${tmp}')"
  exit 2
fi

declare -i _version=$(( (BASH_REMATCH[1]*10**6) + (BASH_REMATCH[2]*10**3) + BASH_REMATCH[3] ))
if (( _version < 18000 )); then
  echo "jsonnet version too old; aborting"
  exit 2
fi

for RELEASE in "${BUILDPATH}"/libraries/*
do
  JSONNET_LIB_PATH="${RELEASE}/vendor"
  echo "$JSONNET_LIB_PATH"
  (cd "$JSONNET_LIB_PATH"/../; jb update)
done


