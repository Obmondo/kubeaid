<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

<h1>Security</h1>

This document covers the current status of security measures.

<!-- TOC -->
* [Helm Chart Trust Chain](#helm-chart-trust-chain)
* [Kubernetes Security Enforcements](#kubernetes-security-enforcements)
* [NetworkPolicies](#networkpolicies)
<!-- TOC -->

# Helm Chart Trust Chain

Helm charts are signed and validated against GPG keys in `helmfile/files/gpg-pubkeys`.

For more details on Chart validation, please visit: https://helm.sh/docs/topics/provenance/

All charts except the ones mentioned below are verifiable:

| Repository        | Verifiable |
|-------------------|:----------:|
| open-xchange-repo |     no     |

# Kubernetes Security Enforcements

This list gives you an overview of default security settings and whether they comply with security standards:

⟶ Visit our generated detailed [Security Context](./docs/security-context.md) overview.

# NetworkPolicies

Kubernetes NetworkPolicies are an essential measure to secure your Kubernetes apps and clusters.
When applied, they restrict traffic to your services.
NetworkPolicies protect other deployments in your cluster or other services in your deployment from getting compromised when another
component is compromised.

We ship a default set of Otterize ClientIntents via
[Otterize intents operator](https://github.com/otterize/intents-operator) which translates intent-based access control
(IBAC) into Kubernetes native NetworkPolicies.

This requires the Otterize intents operator to be installed.

```yaml
security:
  otterizeIntents:
    enabled: true
```
