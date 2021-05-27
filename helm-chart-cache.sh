#!/bin/bash

set -euo pipefail

export HELM_EXPERIMENTAL_OCI=1

while getopts p:r:u: flag
do
    case "${flag}" in
        p) password=${OPTARG};;
        r) registry=${OPTARG};;
        u) username=${OPTARG};;
    esac
done

helm registry login $registry --username $username --password $password

for path in $(find argocd-helm-charts -maxdepth 1 -mindepth 1 -type d);
do
	echo "### Attempting dep up for upstream for $path ###"
	bash helm-dep-up.sh -u true -p $path -r $registry;
	chartname=$(basename $path);
	if [ -d "$path/charts" ]; then
		for tars in $path/charts/*.tgz
		do
			tgzfile=$(basename $tars);
			version=$(echo $tgzfile | grep -o "v*[0-9]\{1\}[0-9]*.+*[0-9].*" | sed 's/\.tgz//')
			chartname=$(echo $tgzfile | sed "s/-$version.tgz//")
			set +e
			echo "### Pulling chart $chartname:$version ###"
			helm chart pull $registry/$chartname:$version > /dev/null
			if [ $? -ne 0 ]; then
			    echo "### Saving and pushing chart $chartname:$version ###"
			    helm chart save $tars $registry/$chartname:$version;
			    helm chart push $registry/$chartname:$version;
			    echo "###  Doing dep up for ghcr for $path ###"
			    bash helm-dep-up.sh -u false -p $path -r $registry;
			fi
			tar zxvf $tars -C $path/charts > /dev/null;
		done
		set -e
		for subchart in $(find $path/charts -maxdepth 1 -mindepth 1 -type d)
		do
			echo "### Doing dep up for $subchart ### "
			helm dep up $subchart > /dev/null
			if [ -d "$subchart/charts" ]; then
				subchartfiles=$(find $subchart/charts -maxdepth 1 -mindepth 1 -type d)
				for subcharts in $subchartfiles
				do
				    subchartname=$(basename $subcharts);
				    for subchartnameversions in "$subchart/charts/$subchartname*.tgz"
				    do
				        subchartnameversion=$(basename $subchartnameversions)
				        tgzfileversion=$(echo $subchartnameversion | grep -o "[0-9].+*[0-9].*" | sed 's/\.tgz//')
				        set +e
				        echo "### Pulling Chart $registry/$subchartname:$tgzfileversion"
				        helm chart pull $registry/$subchartname:$tgzfileversion > /dev/null
				        if [ $? -ne 0 ]; then
				            echo "### Saving and pushing chart $registry/$subchartname:$tgzfileversion"
				            helm chart save $subchartnameversions $registry/$subchartname:$tgzfileversion;
				            helm chart push $registry/$subchartname:$tgzfileversion;
				        fi
				    done

				done
			fi
		done
    fi
done
