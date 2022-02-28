# gitlab-runner

## installation - connecting to existing gitlab installation

create secret - with runner token from gitlab installation.

```sh
kubectl create secret generic gitlab-runner -n gitlab --from-literal=runner-registration-token=xxxgitlab-runnertoken  --from-literal=runner-token=""
```

(or create via sealedsecrets)

Set values file for your cluster with:

```sh
gitlab-runner:
  gitlabUrl: https://gitlab.yourdomain.tld/
```

Let argocd do the rest

## CI User setup

Copy the files from the gitlab-runner/templates to the desired helm chart and raise the MR to get it merged. Once merged, create the kubeconfig with the script below and it should then be set as variables on the CI.

```bash
#!/bin/bash

set -eou pipefail

CLUSTERNAME=$1
SERVICEACCOUNT=$2
NAMESPACE=$3
CONFIG="/tmp/$CLUSTERNAME.config"

kubectl get secret $(kubectl get serviceaccount $SERVICEACCOUNT -n $NAMESPACE -o yaml | yq eval '.secrets.[].name' -) -n $NAMESPACE -o yaml | yq eval '.data."ca.crt"' - | base64 --decode > /tmp/k8s-$CLUSTERNAME.ca.crt

kubectl config --kubeconfig $CONFIG set-cluster $CLUSTERNAME --embed-certs=true --server="https://kubernetes.default.svc" --certificate-authority=/tmp/k8s-$CLUSTERNAME.ca.crt

kubectl config --kubeconfig $CONFIG set-credentials $SERVICEACCOUNT --token=$(kubectl get secret $(kubectl get serviceaccount $SERVICEACCOUNT -n $NAMESPACE -o yaml | yq eval '.secrets.[].name' -) -n $NAMESPACE -o yaml | yq eval '.data."token"' - | base64 --decode)

kubectl config --kubeconfig $CONFIG set-context $CLUSTERNAME --cluster=$CLUSTERNAME --user=$SERVICEACCOUNT

kubectl config --kubeconfig $CONFIG use-context $CLUSTERNAME

cat $CONFIG | base64 --wrap=0

```
