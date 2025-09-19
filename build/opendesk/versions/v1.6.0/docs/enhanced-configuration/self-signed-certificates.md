<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Self-signed certificates and custom Certificate Authority (CA)</h1>

<!-- TOC -->
* [Configuration](#configuration)
  * [Option 1: Bring Your Own Certificate](#option-1-bring-your-own-certificate)
  * [Option 2a: Use cert-manager.io with auto-generated namespace based root-certificate](#option-2a-use-cert-managerio-with-auto-generated-namespace-based-root-certificate)
  * [Option 2b: Use cert-manager.io with a pre-defined or shared root-certificate](#option-2b-use-cert-managerio-with-a-pre-defined-or-shared-root-certificate)
<!-- TOC -->

This document covers:
* Deploying openDesk into an environment with custom public key infrastructure (PKI) that is usually not part of
public certificate authority chains
* deploying openDesk into a local cluster without ACME challenge

# Configuration

There are two options to address these use case:

## Option 1: Bring Your Own Certificate

This option is useful when you have your own PKI in your environment which is also trusted by all clients that should
access openDesk.

1. Disable cert-manager.io certificate resource creation:

    ```yaml
    certificates:
      enabled: false
    ```

2. Enable mount of self-signed certificates:

    ```yaml
    certificate:
      selfSigned: true
    ```

3. Create a Kubernetes secret named `opendesk-certificates-tls` of type `kubernetes.io/tls` containing either a valid
wildcard certificate or a certificate with [all required subdomains](../../helmfile/environments/default/global.yaml.gotmpl)
set as SANs (Subject Alternative Name).

4. Create a Kubernetes secret with name `opendesk-certificates-ca-tls` of type `kubernetes.io/tls` containing the custom
CA certificate as X.509 encoded (`ca.crt`) and as jks trust store (`truststore.jks`).

5. Create a Kubernetes secret with name `opendesk-certificates-keystore-jks` with key `password` and as value the jks
trust store password.

## Option 2a: Use cert-manager.io with auto-generated namespace based root-certificate

This option is useful when you do not have a trusted certificate available and can't fetch a certificate from
Let’s Encrypt. It will result in a cert-manager managed root certificate in the namespace you deploy openDesk into.

1. Create self-signed cert-manager.io Cluster Issuer:
    ```yaml
    apiVersion: "cert-manager.io/v1"
    kind: "ClusterIssuer"
    metadata:
      name: "selfsigned-issuer"
    spec:
      selfSigned: {}
    ```

2. Enable mount and creation of self-signed certificates:
    ```yaml
    certificate:
      issuerRef:
        name: "selfsigned-issuer"
      selfSigned: true
    ```

## Option 2b: Use cert-manager.io with a pre-defined or shared root-certificate

Use this approach if you like to use a pre-created CA root certificate that can be "shared" (as copy) between
multiple namespaces in a cluster.

1. Create self-signed cert-manager.io Cluster Issuer root certificate the same way as in *Option 2a*.

2. Create the root certificate for the previously created CA, in the example it is placed into the namespace `cert-manager`.
    ```yaml
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: opendesk-root
      namespace: cert-manager
    spec:
      isCA: true
      commonName: opendesk.eu
      secretName: opendesk-root-cert-secret
      subject:
        organizations: [ "openDesk cluster root certificate organization" ]
      privateKey:
        algorithm: ECDSA
        size: 256
      issuerRef:
        name: selfsigned-issuer
        kind: ClusterIssuer
        group: cert-manager.io
      duration: 87600h # 10y
      renewBefore: 87599h
    ```

3. Copy this certificates secret into all namespaces you want to make use of the certificate in.

4. Create an issuer resource in all namespaces you want to make use of the certificate in.

>The latter two steps are part of the `env-start:` section within [`.gitlab-ci.yml`](../../.gitlab-ci.yml).
