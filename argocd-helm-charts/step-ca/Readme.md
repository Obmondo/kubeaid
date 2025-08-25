# Smallstep Setup

## Introduction

Smallstep with cert-manager to setup internal CA with acme as a provisioner.
trust-manager will trust the cert when pod(client) wants to talk ingress(Traefik/Nginx)

### Steps

> NOTE: you need cert-manager to be installed on your k8s cluster.

* Deploy step-ca app from [kubeaid/step-ca](https://github.com/Obmondo/kubeaid/tree/master/argocd-helm-charts/step-ca) which will deploy step-certificate, step-issuer, autocert (tls between services) and trust-manager

* Fix values.yaml in your kubeaid-config repo

(example values file)[./examples/values.yaml]

* Set up stepClusterIssuer and add in the values file
  NOTE: you can only access the step certificate once the step-certificate pod is ready

```sh
kubectl get -n step-ca -o jsonpath="{.data['root_ca\.crt']}" configmaps/step-ca-step-certificates-certs | base64 | tr -d '\n'

kubectl get -n step-ca -o jsonpath="{.data['ca\.json']}" configmaps/step-ca-step-certificates-config | jq -r .authority.provisioners[0].key.kid)
```

* Expose the root CA inside a POD.
  NOTE: you can achieve this in multiple way.
  * Mounting the secret directly
  * Passing an env
  * Inject the root ca directly via webhook (k8s)

  Golang can read `SSL_CERT_FILE` in which root_ca is present, so client can accept tls when its is signed by an internal CA.
