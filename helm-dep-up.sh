#!/bin/bash

## The script runs the helm dep up command based on what is the value of upstream
## Is upstream is true - it downloads the charts from upstream repo url and if false
## It download charts from our ghcr repo
## path is the helm chart path

## USAGE - ./helm-dep-up.sh -u true -p argocd-helm-charts/yetibot

set -euo pipefail

export HELM_EXPERIMENTAL_OCI=1

oci=true

while getopts u:p:r:o: flag
do
    case "${flag}" in
        u) upstream=${OPTARG};;
        p) path=${OPTARG};;
        r) registry=${OPTARG};;
        o) oci=${OPTARG};;
        *) >&2 echo "Invalid flag '$flag', exiting"; exit 1
    esac
done

if [[ "$oci" == true ]]; then
  version=$(grep -E "  version:.+" "${path}/Chart.yaml")
  versionnum=$(cut -d':' -f2 <<< "${version}" | sed -e 's/^[[:space:]]*//')
  chartname=$(basename "$path")
  if ! helm chart pull "${registry}/${chartname}:${versionnum}" && [ "${upstream}" == true ]; then
    echo "### Doing dep up for upstream for ${path} and ${versionnum} ###"

    if [ -f "${path}/Chart.yaml" ]; then
      sed -ri -e 's/# *(repository: https?:)/\1/g' "${path}/Chart.yaml"
      sed -ri -e 's/(repository: "oci)/# \1/g' "${path}/Chart.yaml"
    fi
  elif [ "$upstream" == false ]; then
    echo "### Doing dep up for ghcr for ${path} and ${versionnum} ###"
    sed -ri -e 's/# *(repository: "oci)/\1/g' "${path}/Chart.yaml"
    sed -ri -e 's/(repository: https?:)/# \1/g' "${path}/Chart.yaml"
  else
    echo "### Ignoring dep up for upstream since ${versionnum} is already present for $path ###"
    exit 0
  fi

else
  sed -ri -e 's/#(repository: https?:)/\1/g' "${path}/Chart.yaml"
  sed -i -e 's/repository: "oci/#repository: "oci/g' "${path}/Chart.yaml"
fi

helm dep up "${path}" > /dev/null
