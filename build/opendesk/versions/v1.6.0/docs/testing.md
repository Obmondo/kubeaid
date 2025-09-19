<!--
SPDX-FileCopyrightText: 2025 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Testing</h1>

<!-- TOC -->
* [Overview](#overview)
* [Test concept](#test-concept)
  * [Rely on upstream applications QA](#rely-on-upstream-applications-qa)
  * [Functional QA (end-to-end tests)](#functional-qa-end-to-end-tests)
    * [Nightly testing](#nightly-testing)
    * [Reporting test results](#reporting-test-results)
  * [Load- and performance testing](#load--and-performance-testing)
    * [Base performance testing](#base-performance-testing)
    * [Load testing to saturation point](#load-testing-to-saturation-point)
    * [Load testing up to a defined user count](#load-testing-up-to-a-defined-user-count)
    * [Overload/recovery tests](#overloadrecovery-tests)
<!-- TOC -->

# Overview

The following section provides an overview of the testing approach adopted to ensure the quality and reliability of openDesk. This concept balances leveraging existing quality assurance (QA) processes with targeted testing efforts tailored to the specific needs of openDesk. The outlined strategy focuses on three key areas:

1. Relying on application QA: Utilizing the existing QA processes of the applications to ensure baseline functionality and quality standards.
2. Minimal functional QA: Executing end-to-end tests to validate critical workflows and ensure that key functionalities operate as expected.
3. Extensive load and performance testing: Conducting comprehensive load and performance tests to assess openDesk's scalability and responsiveness under varying usage conditions.

These efforts are designed to complement each other, minimizing redundancy while ensuring robust testing coverage.

# Test concept

## Rely on upstream applications QA

openDesk contains applications from different suppliers. As a general approach, we rely on the testing
conducted by these suppliers for their respective applications.

We review the supplier's QA measures on a regular basis, to ensure a reliable and sufficient QA of the underlying applications.

We receive the release notes early before a new application release is integrated into openDesk, so
we are able to check for the existence of a sufficient set of test cases.
The suppliers create a set of test cases for each new function.

## Functional QA (end-to-end tests)

We develop and maintain a [set of end-to-end tests](https://gitlab.opencode.de/bmi/opendesk/deployment/e2e-tests) focussing on:

- use cases that are spanning more than a single application, e.g.
  - the filepicker in OX App Suite for selecting files from Nextcloud or
  - the central navigation that is part of the top bar of most applications.
- openDesk specific configurations/supported settings that can be found in the `functional.yaml.gotmpl`, e.g.
  - SSO federation or
  - sharing settings for Nextcloud.
- bugs identified in the past, e.g.
  - creating a folder in OX or
  - enforcement of an account's password renewal.

We execute the tests using English and German as language profile.

The development team utilizes the test automation described above for QA'ing their feature branches.

### Nightly testing

We use the functional e2e-tests in nightly testruns on a matrix of deployments addressing different application profiles to ensure the quality of the development branch's current state.

The following naming scheme is applied for the deployment matrix:

- `<edition>-<type>-<profile>` resulting e.g. in  `ce-init-default` or `ee-upgr-extsrv`

**`<edition>`**

- `ce`: openDesk Community Edition
- `ee`: openDesk Enterprise Edition

**`<type>`**

- `init`: Initial / fresh / from the scratch deployment of `develop` branch into an empty namespace.
- `upgr`: Deploy latest migration release (needs to be pinned manually) into an empty namespace, afterwards run upgrade deployment with current state of `develop` branch.
- `upd`: Deploy latest release (`main` branch) into an empty namespace, afterwards run upgrade deployment with current state of `develop` branch.

**`<profile>`**: The following profiles are defined
- `default`: With
  - *`functional.yaml`*: No changes beside specific `2FA testing` group and enabled UDM REST API (required for user import).
  - *Services*: Internal services deployed with openDesk are used.
  - *Secrets*: Master password based secrets based on `secrets.yaml.gotmpl`
  - *Certificates*: Letsencrypt-prod certificates are used.
  - *Deployment*: GitLab CI based deployment.
- `funct1`: Different configuration of `functional.yaml`, self-signed-certs [and when available external secrets].
- `extsrv`: External services (where possible).
- `gitops`: Argo CD based deployment.

### Reporting test results

All executions of the end-to-end tests are tracked in a central platform running [Allure TestOps](https://docs.qameta.io/allure-testops/).

As the TestOps tool contains infrastructure details of our development and test clusters it is currently only accessible for to project members.

## Load- and performance testing

Our goal is to deliver openDesk as application-grade software with the ability to serve large user bases.

We create and perform [load- and performance tests](https://gitlab.opencode.de/bmi/opendesk/deployment/load-tests) for each release of openDesk.

Our approach consists of different layers of load testing.

### Base performance testing

For these tests we define a set of "normal", uncomplicated user-interactions with openDesk.

For each testcase in this set, we measure the duration of the whole testcase (and individual steps within the
testcase) on a given, unloaded environment, prepared with a predefined setup and openDesk release installed.

As a result, we receive the total runtime of one iteration of the given testcase, the runtime of each
step inside the testcase, the error rate and min/max/median runtimes.

Most importantly, the environment should not be used by other users or have running background tasks, so it should
be an environment in a mostly idle state.

The results can be compared with the results of the previous release, so we can see if changes
in software components improve or decrease the performance of a testcase.

### Load testing to saturation point

These tests are performed to ensure the correct processing and user interaction, even under
high-load scenarios.

We use the same test cases as in the base performance tests.

Now we measure the duration on a well-defined environment while the system is being used
by a predefined number of test users in parallel. The number of users is incrementally scaled up.

Our goal is to see constant runtimes of each testcase iteration, despite the increased overall throughput due to the increasing number of parallel users.

At a certain point, increasing the number of users does not lead to higher overall throughput, but instead leads to an increase in the runtime of each testcase iteration.

This point, the saturation point, is the load limit of the environment. Up to this point, the
environment and the installed software packages can handle the load. Beyond this point, response times increase and error rates rise.

### Load testing up to a defined user count

For partners interested in large scale openDesk deployments,
we offer a tailored workshop in which we define scenarios and perform load testing analysis.

This way, we can help you decide on the appropriate sizing for the planned openDesk deployment.

### Overload/recovery tests

If necessary, we perform overload tests, which will saturate the system with multiple
test cases until no further increase in throughput is visible. Then we add even more load
until the first HTTP requests run into timeouts or errors.
After a few minutes, we reduce the load below the saturation point.
Now we can check if the system is able to recover from the overload status.
