#!/bin/bash

set -euo pipefail

tmp_dir=$(mktemp -d)

get_chartName() {
    if echo $1 | grep -q 'argocd-clusters-managed'; then
        chartName=$(basename $1 | cut -d"." -f1 | sed 's|values-||')
    elif echo $1 | grep -q 'argocd-helm-charts'; then
        chartName=$(echo $1 | grep 'argocd-helm-charts' | cut -d"/" -f2)
    fi

    echo $chartName
}

#update so we have latest origin/master
git fetch

for i in $(git diff --name-only origin/master | grep -E "argocd-clusters-managed/[a-z0-9-]+/values[a-z0-9-]*.yaml|argocd-helm-charts/[a-z0-9-]+/values.yaml"); do
    filename=$(basename $i)
    cp $i $tmp_dir/$filename;
    # I have no idea what the below line is suppose to do. Contact Klavs for ref.
    git diff origin/master -- ${i} | (cd $tmp_dir; patch -p3 -R)
    chartName=$(get_chartName $i)
    commit_id=$(git log --format="%H" -n 1 -- $i)
    echo -e "Found value file change: $i - in commit: $commit_id\nresulting in a change to helm chart /argocd-helm-charts/$chartName output"

    bash helm-dep-up.sh -u true -p argocd-helm-charts/$chartName -r ghcr.io/Obmondo -o false
    
    helm_current=$(helm template -n $chartName argocd-helm-charts/$chartName --values argocd-helm-charts/$chartName/values.yaml --values $i)
    helm_old=$(helm template -n $chartName argocd-helm-charts/$chartName --values argocd-helm-charts/$chartName/values.yaml --values $tmp_dir/$filename)

    if [ "$helm_current" == "$helm_old" ]; then
        echo "You have modified ${i} - but the corresponding Helm chart showed NO changes. We do not allow changes to Helm chart value files without them having an effect on the chart output. Failing!"
        exit 1
    fi
done
