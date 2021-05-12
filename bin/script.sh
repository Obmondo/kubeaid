#!/bin/bash

set -eu

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

for i in $(git diff --name-only origin/master | grep 'values'); do
    filename=$(basename $i)
    cp $i $tmp_dir/$filename;
    # I have no idea what the below line is suppose to do. Contact Klavs for ref.
    git diff --name-only origin/master -- ${filename} | (cd $tmp_dir; patch -p3 -R)
    chartName=$(get_chartName $i)
    commit_id=$(git log --format="%H" -n 1 -- $i)

    echo -e "Found value file change: $i - in commit: $commit_id\nresulting in a change to helm chart /argocd-helm-charts/$chartName output"

    # Update helm repo and charts to ensure that doesn't cause a template output mismatch
    helm template --dependency-update argocd-helm-charts/$chartName &>/dev/null

    helm_current=$(helm template --dependency-update argocd-helm-charts/$chartName --values $i --api-versions v1 --api-versions apiregistration.k8s.io/v1 --api-versions apiregistration.k8s.io/v1beta1 --api-versions apps/v1 --api-versions events.k8s.io/v1 --api-versions events.k8s.io/v1beta1 --api-versions authentication.k8s.io/v1 --api-versions authentication.k8s.io/v1beta1 --api-versions authorization.k8s.io/v1 --api-versions authorization.k8s.io/v1beta1 --api-versions autoscaling/v1 --api-versions autoscaling/v2beta1 --api-versions autoscaling/v2beta2 --api-versions batch/v1 --api-versions batch/v1beta1 --api-versions certificates.k8s.io/v1 --api-versions certificates.k8s.io/v1beta1 --api-versions networking.k8s.io/v1 --api-versions networking.k8s.io/v1beta1 --api-versions extensions/v1beta1 --api-versions policy/v1beta1 --api-versions rbac.authorization.k8s.io/v1 --api-versions rbac.authorization.k8s.io/v1beta1 --api-versions storage.k8s.io/v1 --api-versions storage.k8s.io/v1beta1 --api-versions admissionregistration.k8s.io/v1 --api-versions admissionregistration.k8s.io/v1beta1 --api-versions apiextensions.k8s.io/v1 --api-versions apiextensions.k8s.io/v1beta1 --api-versions scheduling.k8s.io/v1 --api-versions scheduling.k8s.io/v1beta1 --api-versions coordination.k8s.io/v1 --api-versions coordination.k8s.io/v1beta1 --api-versions node.k8s.io/v1 --api-versions node.k8s.io/v1beta1 --api-versions discovery.k8s.io/v1beta1 --api-versions flowcontrol.apiserver.k8s.io/v1beta1 --api-versions acme.cert-manager.io/v1 --api-versions acme.cert-manager.io/v1beta1 --api-versions acme.cert-manager.io/v1alpha3 --api-versions acme.cert-manager.io/v1alpha2 --api-versions ceph.rook.io/v1 --api-versions cert-manager.io/v1 --api-versions cert-manager.io/v1beta1 --api-versions cert-manager.io/v1alpha3 --api-versions cert-manager.io/v1alpha2 --api-versions crd.projectcalico.org/v1 --api-versions monitoring.coreos.com/v1 --api-versions monitoring.coreos.com/v1alpha1 --api-versions argoproj.io/v1alpha1 --api-versions bitnami.com/v1alpha1 --api-versions objectbucket.io/v1alpha1 --api-versions traefik.containo.us/v1alpha1 --api-versions rook.io/v1alpha2 --api-versions metrics.k8s.io/v1beta1 --include-crds)
    helm_old=$(helm template --dependency-update argocd-helm-charts/$chartName --values $tmp_dir/$filename --api-versions v1 --api-versions apiregistration.k8s.io/v1 --api-versions apiregistration.k8s.io/v1beta1 --api-versions apps/v1 --api-versions events.k8s.io/v1 --api-versions events.k8s.io/v1beta1 --api-versions authentication.k8s.io/v1 --api-versions authentication.k8s.io/v1beta1 --api-versions authorization.k8s.io/v1 --api-versions authorization.k8s.io/v1beta1 --api-versions autoscaling/v1 --api-versions autoscaling/v2beta1 --api-versions autoscaling/v2beta2 --api-versions batch/v1 --api-versions batch/v1beta1 --api-versions certificates.k8s.io/v1 --api-versions certificates.k8s.io/v1beta1 --api-versions networking.k8s.io/v1 --api-versions networking.k8s.io/v1beta1 --api-versions extensions/v1beta1 --api-versions policy/v1beta1 --api-versions rbac.authorization.k8s.io/v1 --api-versions rbac.authorization.k8s.io/v1beta1 --api-versions storage.k8s.io/v1 --api-versions storage.k8s.io/v1beta1 --api-versions admissionregistration.k8s.io/v1 --api-versions admissionregistration.k8s.io/v1beta1 --api-versions apiextensions.k8s.io/v1 --api-versions apiextensions.k8s.io/v1beta1 --api-versions scheduling.k8s.io/v1 --api-versions scheduling.k8s.io/v1beta1 --api-versions coordination.k8s.io/v1 --api-versions coordination.k8s.io/v1beta1 --api-versions node.k8s.io/v1 --api-versions node.k8s.io/v1beta1 --api-versions discovery.k8s.io/v1beta1 --api-versions flowcontrol.apiserver.k8s.io/v1beta1 --api-versions acme.cert-manager.io/v1 --api-versions acme.cert-manager.io/v1beta1 --api-versions acme.cert-manager.io/v1alpha3 --api-versions acme.cert-manager.io/v1alpha2 --api-versions ceph.rook.io/v1 --api-versions cert-manager.io/v1 --api-versions cert-manager.io/v1beta1 --api-versions cert-manager.io/v1alpha3 --api-versions cert-manager.io/v1alpha2 --api-versions crd.projectcalico.org/v1 --api-versions monitoring.coreos.com/v1 --api-versions monitoring.coreos.com/v1alpha1 --api-versions argoproj.io/v1alpha1 --api-versions bitnami.com/v1alpha1 --api-versions objectbucket.io/v1alpha1 --api-versions traefik.containo.us/v1alpha1 --api-versions rook.io/v1alpha2 --api-versions metrics.k8s.io/v1beta1 --include-crds)

    if [ "$helm_current" == "$helm_old" ]; then
        echo "You have modified ${i} - but the corresponding Helm chart showed NO changes. We do not allow changes to Helm chart value files without them having an effect on the chart output. Failing!"
        exit 1
    fi
done
