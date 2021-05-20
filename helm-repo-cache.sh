#!/bin/bash

set -euo pipefail

mkdir -p helm-repo-cache

for path in $(find argocd-helm-charts -maxdepth 1 -mindepth 1 -type d);
do
	helm dep up $path;
	tar zxvf $path/charts/*.tgz -C $path/charts;
	echo $(find $path/charts -maxdepth 1 -mindepth 1 -type d);
	helm dep up $(find $path/charts -maxdepth 1 -mindepth 1 -type d);
	for tgzfiles in $(find "$path" -name *.tgz);
	do
		mv $tgzfiles helm-repo-cache;
	done
done

while getopts u: flag
do
    case "${flag}" in
        u) url=${OPTARG};;
    esac
done

helm repo index helm-repo-cache/ --url $url
