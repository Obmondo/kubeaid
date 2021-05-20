#!/bin/bash

set -euo pipefail

export HELM_EXPERIMENTAL_OCI=1

while getopts p:r: flag
do
    case "${flag}" in
        p) password=${OPTARG};;
        r) registry=${OPTARG};;
    esac
done

helm registry login $registry --username Obmondo --password $password

for path in $(find argocd-helm-charts -maxdepth 1 -mindepth 1 -type d);
do
	echo "### Attempting dep up for upstream for $path ###"
	bash helm-dep-up.sh -u true -p $path -r $registry;
	chartname=$(basename $path);
	if [ -d "$path/charts" ]; then
		tgzfile=$(basename $path/charts/*.tgz);
		version=$(echo $tgzfile | rev | cut -d'-' -f1 | rev | sed 's/\.tgz//')
		set +e
		echo "### Pulling chart $chartname:$version ###"
		helm chart pull $registry/$chartname:$version > /dev/null
		if [ $? -ne 0 ]; then
		    echo "### Saving and pushing chart $chartname:$version ###"
		    helm chart save $path $registry/$chartname:$version;
		    helm chart push $registry/$chartname:$version;
		fi
		set -e
		tar zxvf $path/charts/*.tgz -C $path/charts > /dev/null;
		for subchart in $(find $path/charts -maxdepth 1 -mindepth 1 -type d)
		do
			echo "### Doing dep up for $subchart ### "
			helm dep up $subchart > /dev/null
			if [ -d "$subchart/charts" ]; then
				subchartfiles=$(find $subchart/charts -maxdepth 1 -mindepth 1 -type d)
				for subcharts in $subchartfiles
				do
				    subchartname=$(basename $subcharts);
				    if [ -f "$subchart/charts/$subchartname*.tgz" ]; then
				    	subchartnameversion=$(find $subchart/charts/$subchartname*.tgz)
				        subchartnameversion=$(basename $subchartnameversion)
				        tgzfileversion=$(basename $subchartnameversion | rev | cut -d'-' -f1 | rev | sed 's/\.tgz//')
				        set +e
				        echo "### Pulling Chart $registry/$subchartname:$tgzfileversion"
				        helm chart pull $registry/$subchartname:$tgzfileversion > /dev/null
				        if [ $? -ne 0 ]; then
				            echo "### Saving and pushing chart $registry/$subchartname:$tgzfileversion"
				            helm chart save $subcharts $registry/$subchartname:$tgzfileversion;
				            helm chart push $registry/$subchartname:$tgzfileversion;
				        fi
				    fi

				done
			fi
		done
	    echo "### Attempting dep up for ghcr for $path ###"
	    bash helm-dep-up.sh -u false -p $path -r $registry;
    fi
done
