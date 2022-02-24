#!/bin/bash

set -euo pipefail

mkdir -p helm-repo-cache

find argocd-helm-charts -maxdepth 1 -mindepth 1 -type d | while read -r path; do
  helm dep up "$path"
  tar zxvf "${path}"/charts/*.tgz -C "${path}/charts"
  find "${path}/charts" -maxdepth 1 -mindepth 1 -type d
  find "${path}/charts" -maxdepth 1 -mindepth 1 -type d -exec xargs helm dep up +
  find "$path" -name '*.tgz' | while read -r tgzfile; do
    mv "$tgzfile" helm-repo-cache;
  done
done

while getopts u: flag; do
  case "${flag}" in
    u) url=${OPTARG};;
    *) >&2 echo "Invalid argument '${flag}', exiting"; exit 1
  esac
done

helm repo index helm-repo-cache/ --url "$url"
