<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

<h1>CI/CD</h1>

This page covers openDesk deployment automation via Gitlab CI.

<!-- TOC -->
* [Deployment](#deployment)
* [Tests](#tests)
<!-- TOC -->

# Deployment

The project includes a `.gitlab-ci.yml` that allows you to execute the deployment from a GitLab instance of your choice.

When starting the pipeline through the GitLab UI, you will be queried for some variables, including the following:

- `DOMAIN`: The primary domain for your deployment, making the openDesk services available, e.g., as `https://portal.DOMAIN`.
- `MAIL_DOMAIN` (optional): The domain for the users' email addresses; it defaults to `DOMAIN`.
- `MATRIX_DOMAIN` (optional): The domain for the users' Matrix IDs; it defaults to `DOMAIN`.
- `NAMESPACE`: Namespace of your K8s cluster openDesk will be installed.
- `MASTER_PASSWORD_WEB_VAR`: Overwrites value of `MASTER_PASSWORD`.

You might want to set credential variables in the GitLab project at `Settings` > `CI/CD` > `Variables`, the values of which can then be hidden from output logs.

# Tests

The GitLab CI pipeline contains a job named `run-tests` that can trigger a test suite pipeline on another GitLab project.
For the trigger to work, the variable `TESTS_PROJECT_URL` has to be set on this GitLab project's CI variables,
which can be found at `Settings` -> `CI/CD` -> `Variables`. The variable should have this format:
`<domain of gitlab>/api/v4/projects/<id>`.
To select the current test suite, use the variable `TESTS_TESTSET`. Default: `Smoke`.
If the branch of the test pipeline is not `main`, this can be set with the `.gitlab-ci.yml` variable
`TESTS_BRANCH` while creating a new pipeline.

The variable `testprofile` within the job is set to `Namespace`, which tells the e2e tests to use environment-specific settings that will be read from the cluster and namespace-specific file which is found in the project internal `opendesk-env` repository.
