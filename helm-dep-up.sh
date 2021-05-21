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
    esac
done

set +e
if $oci
then
	version=$(grep -E "  version*" $path/Chart.yaml)
	versionnum=$(echo $version | cut -d':' -f2 | sed -e 's/^[[:space:]]*//')
	chartname=$(echo $path | rev | cut -d'/' -f1 | rev)
	helm chart pull $registry/$chartname:$versionnum > /dev/null
	if [ $? -ne 0 ]
	then
	    echo "### Doing dep up for upstream for $path and $versionnum ###"
		if [ -f "$path/Chart.yaml" ]; then
			if $upstream
			then
			    sed -i -e 's/#repository: https:/repository: https:/g' $path/Chart.yaml
			    sed -i -e 's/#repository: http:/repository: http:/g' $path/Chart.yaml
			    sed -i -e 's/repository: "oci/#repository: "oci/g' $path/Chart.yaml
			    helm dep up $path > /dev/null
			else
			    sed -i -e 's/#repository: "oci/repository: "oci/g' $path/Chart.yaml
			    sed -i -e 's/repository: https:/#repository: https:/g' $path/Chart.yaml
			    sed -i -e 's/repository: http:/#repository: http:/g' $path/Chart.yaml
			    helm dep up $path > /dev/null
		        fi
		fi
	else
		echo "### Ignoring dep up since $versionnum is already present for $path ###"
	fi

else
	sed -i -e 's/#repository: https:/repository: https:/g' $path/Chart.yaml
	sed -i -e 's/#repository: http:/repository: http:/g' $path/Chart.yaml
	sed -i -e 's/repository: "oci/#repository: "oci/g' $path/Chart.yaml
	helm dep up $path > /dev/null
fi
