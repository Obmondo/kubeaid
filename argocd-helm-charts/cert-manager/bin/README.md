# Cleaning orphaned secrets for cert-manager

## Source

https://github.com/richstokes/k8s-scripts/

## Description

* You will sometimes encounter error messages such as these in the logs for cert-manager's `cainjector` pod:

```text
E1124 08:09:45.831036       1 indexers.go:61] "cert-manager: unable to fetch certificate that owns the secret" err="Certificate.cert-manager.io \"kubeaid-obmondo-web-app-317-tls\" not found" kind="customresourcedefinition" type="customresourcedefinition" secret="obmondo-ci/kubeaid-obmondo-web-app-317-tls" certificate="obmondo-ci/kubeaid-obmondo-web-app-317-tls"
```

## Why it happens

* What causes these errors are orphaned secrets in the namespace.

* Secrets created by an ingress resource will remain in the namespace even after the ingress that created them has been deleted, they are not auto-cleaned.

* `cert-manager` looks at these orphaned secret and trys to do something with them, but the resources that owned them are already gone, so these messages start to fill up the `cainjector` logs as more and more secrets are orphaned.

* `cert-manager` does support garbage-collection for these secrets, however it is not the default (as it has the downside of taking down production services if you accidentally delete any CRDs). So using this script is much safer.

## How the script works

* This script will find TLS secrets in a given namespace which have no matching certificate resource and delete them.  

## Usage

```sh
./argocd-helm-charts/cert-manager/bin/clean-orphans.sh <namespace>
```

* Specifying no namespace will check the default. You will be prompted before anything is deleted.  
