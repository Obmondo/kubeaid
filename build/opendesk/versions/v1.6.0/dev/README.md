<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Tools for local development</h1>

* [charts-local.py](#charts-localpy)
  * [Commandline parameter](#commandline-parameter)
    * [`--match <your_string>`](#--match-your_string)
    * [`--revert`](#--revert)
    * [`--branch` (deprecated)](#--branch-deprecated)

# charts-local.py

This script helps you with cloning/pulling Helm charts and referencing them directly in the openDesk
Helmfile deployment for comfortable local test and development. The charts will be cloned/pulled into a directory
created next to the `opendesk` repo containing this documentation and the `charts-local.py` script.

The name of the directory containing the charts is based on the (currently) selected branch of the openDesk
repo prefixed with `charts-`.

The script will create `.bak` copies of the helmfiles that have been touched that can easily be reverted to
using the `--revert` option.

Run the script with `-h` to get information about the script's parameter on commandline.

## Commandline parameter

### `--match <your_string>`

Will only fetch repos or pull images for charts which name matches `<your_string>`.

### `--revert`

Reverts the changes in the helmfiles pointing to the local Helm charts by copying the backup files created by the
scripts itself back to their original location.

### `--branch` (deprecated)

Optional parameter: Defines a branch for the `opendesk` repo to work with. The script will create the branch if it
does not exist yet. Otherwise it will switch to defined branch.

If parameter is omitted the current branch of the `opendesk` repo will be used.

As this parameter was used rarely, we might remove the support in a later version.
