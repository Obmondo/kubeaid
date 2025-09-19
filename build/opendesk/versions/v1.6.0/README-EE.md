<!--
SPDX-FileCopyrightText: 2024-2025 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>openDesk Enterprise Edition</h1>

<!-- TOC -->
* [Enabling the Enterprise deployment](#enabling-the-enterprise-deployment)
* [Configuring the oD EE deployment for self-hosted installations](#configuring-the-od-ee-deployment-for-self-hosted-installations)
  * [Registry access](#registry-access)
  * [License keys](#license-keys)
* [Component overview](#component-overview)
  * [CE Components](#ce-components)
  * [EE Components](#ee-components)
    * [Collabora](#collabora)
    * [Element](#element)
    * [Nextcloud](#nextcloud)
    * [Open-Xchange](#open-xchange)
      * [OX App Suite](#ox-app-suite)
      * [OX Dovecot](#ox-dovecot)
<!-- TOC -->

openDesk Enterprise Edition is recommended for production use. It receives support and patches from ZenDiS and the suppliers of the components due to the included product subscriptions.

This document refers to the openDesk Community Edition as "oD CE" and the openDesk Enterprise Edition as "oD EE".

Please contact [ZenDiS](mailto:opendesk@zendis.de) to get openDesk Enterprise, either as a SaaS offering or for your on-premises installation.

# Enabling the Enterprise deployment

To enable the oD EE deployment you must set the environment variable `OPENDESK_ENTERPRISE` to any value that does not evaluate to boolean *false* for [Helm flow control](https://helm.sh/docs/chart_template_guide/control_structures/#ifelse), e.g. `"true"`, `"yes"` or `"1"`:

```shell
OPENDESK_ENTERPRISE=true
```

> **Note**
> Upgrading from oD CE to EE is currently not supported, especially due to the fact it requires a migration
> from Dovecot 2.x (standard storage) to Dovecot Pro 3.x (S3).

# Configuring the oD EE deployment for self-hosted installations

## Registry access

With openDesk EE you get access to the related artifact registry owned by ZenDiS.

Three steps are required to access the registry - for step #1 and #2 you can set some variables. Below, you can define `<your_name_for_the_secret>` freely, like `enterprise-secret`, as long as it consistent in step #1 and #3.

```shell
NAMESPACE=<your_namespace>
NAME_FOR_THE_SECRET=<your_name_for_the_secret>
YOUR_ENTERPRISE_REGISTRY_USERNAME=<your_registry_credential_username>
YOUR_ENTERPRISE_REGISTRY_PASSWORD=<your_registry_credential_password>
```

1. Add your registry credentials as a secret to the namespace you want to deploy openDesk to. Do not forget to create the namespace if it does not exist yet (`kubectl create namespace ${NAMESPACE}`).

```shell
kubectl create secret --namespace "${NAMESPACE}" \
  docker-registry "${NAME_FOR_THE_SECRET}" \
  --docker-server "registry.opencode.de" \
  --docker-username "${YOUR_ENTERPRISE_REGISTRY_USERNAME}" \
  --docker-password "${YOUR_ENTERPRISE_REGISTRY_PASSWORD}" \
  --dry-run=client -o yaml | kubectl apply -f -
```

2. Docker login to the registry to access Helm charts for local deployments:

```shell
docker login registry.opencode.de -u ${YOUR_ENTERPRISE_REGISTRY_USERNAME} -p ${YOUR_ENTERPRISE_REGISTRY_PASSWORD}
```

3. Reference the secret from step #1 in the deployment as well as the registry itself for `images` and `helm` charts:

```yaml
global:
  imagePullSecrets:
    - "<your_name_for_the_secret>"
repositories:
  image:
    registryOpencodeDeEnterprise: "registry.opencode.de"
  helm:
    registryOpencodeDeEnterprise: "registry.opencode.de"
```

## License keys

Some applications require license information for their Enterprise features to be enabled. With the aforementioned registry credentials you will also receive a file called [`enterprise.yaml`](./helmfile/environments/default/enterprise_keys.yaml.gotmpl) containing the relevant license keys.

Please place the file next your other `.yaml.gotmpl` file(s) that configure your deployment.

Details regarding the scope/limitation of the component's licenses:

- Nextcloud: Enterprise license to enable [Nextcloud Enterprise](https://nextcloud.com/de/enterprise/) specific features, can be used across multiple installations until the licensed number of users is reached.
- OpenProject: Domain specific enterprise license to enable [OpenProject's Enterprise feature set](https://www.openproject.org/enterprise-edition/), domain matching can use regular expressions.
- XWiki: Deployment specific enterprise license (key pair) to activate the [XWiki Pro](https://xwiki.com/en/offerings/products/xwiki-pro) apps. *Caution! XWiki needs these license keys as one-line strings. Multi-line strings result in installation failure*

# Component overview

## CE Components

The following components are using the same codebase and artifacts for their Enterprise and Community offering:

- Cryptpad
- Jitsi
- Notes
- Nubus
- OpenProject
- XWiki

## EE Components

This section provides information about the components that have - at least partially - Enterprise specific artifacts.

If you want to check in detail which artifacts are specific to openDesk Enterprise and thereby may contain proprietary code, please check the `repository:`
values in the image ([1](./helmfile/environments/default/images.yaml.gotmpl) / [2](./helmfile/environments/default-enterprise-overrides/images.yaml.gotmpl))
and chart ([1](./helmfile/environments/default/charts.yaml.gotmpl) / [2](./helmfile/environments/default-enterprise-overrides/charts.yaml.gotmpl)) definitions.
When a repository path starts with `/zendis`, the artifact is only available in an openDesk Enterprise deployment.

###  Collabora

- Collabora Online (COOL) container image: Is build from the same public source code as Collabora Development Edition (CODE), only the build configurations might differ. COOL includes a brand package that is not public and its license is not open source.
- COOL Controller container image and Helm chart: Source code and chart are using Mozilla Public License Version 2.0, but the source code is not public. It is provided to customers upon request.

openDesk updates Collabora once a COOL image based on the version pattern `<major>.<minor>.<patch>.3+.<build>` was made available. This happens usually at the same time the CODE image with `<major>.<minor>.<patch>.2+.<build>` is made available.

### Element

- AdminBot and GroupSync container image: 100% closed source
- Admin Console container image: 100% closed source, though ~65% of the total runtime code is from the [matrix-bot-sdk](https://github.com/turt2live/matrix-bot-sdk/)

### Nextcloud

- Nextcloud Enterprise: openDesk uses the Nextcloud Enterprise to the build Nextcloud container image for oD EE. The Nextcloud EE codebase might contain EE exclusive (longterm support) security patches, plus the Guard app, that is not publicly available, while it is AGPL-3.0 licensed.

openDesk updates the Nextcloud images for openDesk CE and EE in parallel, therefore we will not upgrade to a new major Nextcloud release before the related Nextcloud Enterprise release is available. When patches are released exclusively for Nextcloud Enterprise, they are made available also exclusively in oD EE.

### Open-Xchange

#### OX App Suite

- OX App Suite Core Middleware container image: The amount of code, that is not open source and has a proprietary license, is <10%.
- OX App Suite Pro Helm chart: It is not publicly available, though it is "just" an umbrella chart re-using the publicly available charts referencing the EE images, so it has <10% prorietary content.

openDesk updates OX App Suite in od CE and EE always to the same release version. Only the App Suíte Pro Helm chart has the same versioning as the actual App Suite release, the chart used in oD CE has a different versioning scheme.

#### OX Dovecot

- Dovecot Pro container image: Dovecot Pro is based on the open source components Dovecot and Pigeonhole but extended by modules providing additional functionality like obox2, cluster, cluster controller and dovecot fts. The additional modules make up about 15% of the overall Dovecot Pro code and are subject to a closed source license.

openDesk aims to keep Dovecot's shared codebases in sync between oD CE and EE, though the versioning between the releases differs (CE: 2.x, EE: 3.y).

Dovecot Pro requires two additional environment variables:

- `DOVECOT_CRYPT_PRIVATE_KEY`
- `DOVECOT_CRYPT_PUBLIC_KEY`

These variables must contain the base64 encoded strings of the private and public
key. These keys can be generated with the following commands:

- Private Key: `openssl genpkey -algorithm X25519 -out private.pem && cat private.pem | base64 -w0`
- Public Key: `openssl pkey -in private.pem -out public.pem -pubout && cat public.pem | base64 -w0`
