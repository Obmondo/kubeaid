<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

# Read me first

Please read the [project's entire CONTRIBUTING.md](https://gitlab.opencode.de/bmi/opendesk/info/-/blob/main/CONTRIBUTING.md) first.

# How to contribute?

Please also read the [project's workflow documentation](./docs/developer/workflow.md) for more details on standards like commit
messages and branching convention.

## Helm vs. Operators vs. Manifests

Due to DVS requirements:

- we have to use [Helm charts](https://helm.sh/) (that can consist of Manifests).
- we should avoid stand-alone Manifests.
- we do not use Operators and CRDs.

In order to align the Helm files from various sources into the unified deployment of openDesk we make use of
[Helmfile](https://github.com/helmfile/helmfile).

## Tooling

New tools should not be introduced without first discussing it with the team. A proposal is fine, but let the team decide if the tool should
be used or not.

We should avoid adding unnecessary complexity.

## In doubt? Ask!

We are always happy to receive contributions, but we also like to discuss technical approaches in order to solve a problem. This helps to ensure
a contribution fits the openDesk platform strategy and roadmap, and potentially avoids otherwise wasted time. So when in doubt please [open an issue](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/-/issues/new) and start a discussion.
