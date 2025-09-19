<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>GitOps Deployment</h1>

<!-- TOC -->
* [Considerations](#considerations)
* [ArgoCD](#argocd)
  * [Option 1: Use YAML manifests](#option-1-use-yaml-manifests)
  * [Option 2: Helmfile plugin](#option-2-helmfile-plugin)
<!-- TOC -->

The recommended deployment method for openDesk is via Helmfile. This can be done "by hand", via CI/CD (Gitlab) or using
the [GitOps](https://about.gitlab.com/topics/gitops/) approach with tools like [Argo CD](https://argoproj.github.io/cd/).

This documentation will use Argo CD to explain how to deploy openDesk GitOps-style.

# Considerations

- openDesk consists of multiple applications which have to be deployed in order.
- During upgrades, migrations have to run before and after applications.

# ArgoCD

We are continuously improving our Argo CD support, please share you experience with Argo CD deployments e.g. by [creating
a ticket](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/issues).

There are two options to deploy openDesk via Argo CD described in the following sections.

## Option 1: Use YAML manifests

This option requires a preprocessing step before using Argo CD. This step requires you to compile the Helmfile based
deployment into Kubernetes YAML manifest, to do so you need to execute the helmfile binary:

```shell
helmfile template > opendesk.yaml
```

References:
- [Helmfile CLI documentation](https://helmfile.readthedocs.io/en/latest/#cli-reference)
- [Generate K8s YAML Manifests for openDesk](https://gitlab.opencode.de/bmi/opendesk/deployment/options/generate-k8s-yaml-manifests)

Afterwards, you can use the resulting manifests within a standard Argo CD workflow.

> **Note**<br>
> When creating the Argo CD application based on the resulting manifests, you must not use the `Automated Sync Policy`
> offered by Argo CD, as you have to manually ensure the applications are updated in the required sequence.

## Option 2: Helmfile plugin

It is possible to deploy openDesk via Argo CD with the community developed
[Helmfile plugin](https://github.com/travisghansen/argo-cd-helmfile).

You can find an example for this approach in the
[Argo CD Deployments](https://gitlab.opencode.de/bmi/opendesk/deployment/options/argocd-deploy) repository.
It contains an example Helm chart (`opendesk-parent`) to create Argo CD Applications via a Helm chart (`opendesk`)
according to `app of apps pattern`. It uses sync waves to ensure the deployment matches requirements and the update sequence
for openDesk is satisfied.
