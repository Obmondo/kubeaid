<!--
SPDX-FileCopyrightText: 2025 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->
<h1>Kubernetes Security Context</h1>

<!-- TOC -->
* [Container Security Context](#container-security-context)
  * [allowPrivilegeEscalation](#allowprivilegeescalation)
  * [capabilities](#capabilities)
  * [privileged](#privileged)
  * [runAsUser](#runasuser)
  * [runAsGroup](#runasgroup)
  * [seccompProfile](#seccompprofile)
  * [readOnlyRootFilesystem](#readonlyrootfilesystem)
  * [runAsNonRoot](#runasnonroot)
* [Status quo](#status-quo)
<!-- TOC -->

# Container Security Context


The containerSecurityContext is the most important security-related section because it has the highest precedence and restricts the container to its minimal privileges.

## allowPrivilegeEscalation


Privilege escalation (such as via set-user-ID or set-group-ID file mode) should not be allowed (Linux only) at any time.

```yaml
containerSecurityContext:
  allowPrivilegeEscalation: false
```

## capabilities


Containers must drop ALL capabilities, and are only permitted to add back the `NET_BIND_SERVICE` capability (Linux only).


**Optimal:**

```yaml
containerSecurityContext:
  capabilities:
    drop:
      - "ALL"
```


**Allowed:**

```yaml
containerSecurityContext:
  capabilities:
    drop:
      - "ALL"
    add:
      - "NET_BIND_SERVICE"
```

## privileged


Privileged Pods eliminate most security mechanisms and must be disallowed.

```yaml
containerSecurityContext:
  privileged: false
```

## runAsUser


Containers should set a user id >= 1000 and never use 0 (root) as user.

```yaml
containerSecurityContext:
  runAsUser: 1000
```

## runAsGroup


Containers should set a group id >= 1000 and never use 0 (root) as user.

```yaml
containerSecurityContext:
  runAsGroup: 1000
```

## seccompProfile


The seccompProfile must be explicitly set to one of the allowed values. An unconfined profile and the complete absence of the profile are prohibited.

```yaml
containerSecurityContext:
  seccompProfile:
    type: "RuntimeDefault"
```


or

```yaml
containerSecurityContext:
  seccompProfile:
    type: "Localhost"
```

## readOnlyRootFilesystem


Containers should have an immutable file systems, so that attackers can not modify application code or download malicious code.

```yaml
containerSecurityContext:
  readOnlyRootFilesystem: true
```

## runAsNonRoot


Containers must be required to run as non-root users.

```yaml
containerSecurityContext:
  runAsNonRoot: true
```

# Status quo


openDesk aims to ensure that all security relevant settings are explicitly templated and comply with security recommendations.


The rendered manifests are also validated against Kyverno [policies](/.kyverno/policies) in CI to ensure that the provided values inside openDesk are properly templated by the Helm charts.


This list gives you an overview of templated security settings and if they comply with security standards:


 - **yes**: Value is set to `true`
 - **no**: Value is set to `false`
 - **n/a**: Not explicitly templated in openDesk; default is used.

| process | status | allowPrivilegeEscalation | privileged | readOnlyRootFilesystem | runAsNonRoot | runAsUser | runAsGroup | seccompProfile | capabilities |
| ------- | ------ | ------------------------ | ---------- | ---------------------- | ------------ | --------- | ---------- | -------------- | ------------ |
| **collabora**/collabora-online | :x: | yes | no | no | yes | 1001 | 1001 | yes | no ["CHOWN","FOWNER","SYS_CHROOT"] |
| **cryptpad**/cryptpad | :x: | no | no | no | yes | 4001 | 4001 | yes | yes |
| **element**/matrix-neoboard-widget | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/matrix-neochoice-widget | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/matrix-neodatefix-bot | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/matrix-neodatefix-bot-bootstrap | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/matrix-neodatefix-widget | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/opendesk-element | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/opendesk-matrix-user-verification-service | :x: | no | no | no | yes | 1000 | 1000 | yes | yes |
| **element**/opendesk-matrix-user-verification-service-bootstrap | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/opendesk-synapse | :white_check_mark: | no | no | yes | yes | 10991 | 10991 | yes | yes |
| **element**/opendesk-synapse-web | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **element**/opendesk-well-known | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **jitsi**/jitsi | :white_check_mark: | no | no | yes | yes | 1993 | 1993 | yes | yes |
| **jitsi**/jitsi/jitsi/jibri | :x: | n/a | n/a | n/a | n/a | n/a | n/a | n/a | no ["SYS_ADMIN"] |
| **jitsi**/jitsi/jitsi/jicofo | :x: | no | no | no | no | 0 | 0 | yes | no |
| **jitsi**/jitsi/jitsi/jigasi | :x: | no | no | no | no | 0 | 0 | yes | no |
| **jitsi**/jitsi/jitsi/jvb | :x: | no | no | no | no | 0 | 0 | yes | no |
| **jitsi**/jitsi/jitsi/prosody | :x: | no | no | no | no | 0 | 0 | yes | no |
| **jitsi**/jitsi/jitsi/web | :x: | no | no | no | no | 0 | 0 | yes | no |
| **jitsi**/jitsi/patchJVB | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **nextcloud**/opendesk-nextcloud-management | :x: | no | no | no | yes | 101 | 101 | yes | yes |
| **nextcloud**/opendesk-nextcloud-notifypush | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **nextcloud**/opendesk-nextcloud/aio | :white_check_mark: | no | no | yes | yes | 101 | 101 | yes | yes |
| **nextcloud**/opendesk-nextcloud/exporter | :white_check_mark: | no | no | yes | yes | 65532 | 65532 | yes | yes |
| **notes**/impress/backend | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **notes**/impress/frontend | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **notes**/impress/yProvider | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **nubus**/intercom-service | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/intercom-service/provisioning | :x: | n/a | n/a | n/a | n/a | n/a | n/a | yes | no |
| **nubus**/opendesk-keycloak-bootstrap | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/keycloak | :x: | no | n/a | no | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusKeycloakBootstrap | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusKeycloakExtensions/handler | :x: | n/a | n/a | n/a | n/a | n/a | n/a | yes | no |
| **nubus**/ums/nubusKeycloakExtensions/proxy | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusLdapNotifier | :x: | no | n/a | yes | yes | 101 | 102 | yes | yes |
| **nubus**/ums/nubusNotificationsApi | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusPortalConsumer | :x: | n/a | n/a | n/a | n/a | n/a | n/a | yes | no |
| **nubus**/ums/nubusPortalFrontend | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusPortalServer | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusProvisioning | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusProvisioning/nats | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusSelfServiceConsumer | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusStackDataUms | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusUdmListener | :x: | no | n/a | yes | yes | 102 | 65534 | yes | yes |
| **nubus**/ums/nubusUdmRestApi | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusUmcGateway | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **nubus**/ums/nubusUmcServer | :x: | no | n/a | yes | yes | 999 | 999 | yes | yes |
| **open-xchange**/dovecot | :x: | no | n/a | yes | n/a | n/a | n/a | yes | no ["CHOWN","DAC_OVERRIDE","KILL","NET_BIND_SERVICE","SETGID","SETUID","SYS_CHROOT"] |
| **open-xchange**/open-xchange/appsuite/core-documentconverter | :x: | no | no | no | yes | 987 | 1000 | yes | yes |
| **open-xchange**/open-xchange/appsuite/core-guidedtours | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/open-xchange/appsuite/core-imageconverter | :x: | no | no | no | yes | 987 | 1000 | yes | yes |
| **open-xchange**/open-xchange/appsuite/core-mw/gotenberg | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **open-xchange**/open-xchange/appsuite/core-ui | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/open-xchange/appsuite/core-ui-middleware | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/open-xchange/appsuite/core-user-guide | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/open-xchange/appsuite/guard-ui | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/open-xchange/nextcloud-integration-ui | :x: | no | no | no | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/open-xchange/public-sector-ui | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/opendesk-open-xchange-bootstrap | :x: | no | n/a | yes | yes | 1000 | 1000 | yes | yes |
| **open-xchange**/postfix-ox | :x: | yes | yes | yes | no | 0 | 0 | yes | no |
| **opendesk-migrations-post**/opendesk-migrations-post | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **opendesk-migrations-pre**/opendesk-migrations-pre | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **opendesk-openproject-bootstrap**/opendesk-openproject-bootstrap | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **opendesk-services**/opendesk-static-files | :x: | no | n/a | yes | yes | 101 | 101 | yes | yes |
| **openproject**/openproject | :white_check_mark: | no | no | yes | yes | 1000 | 1000 | yes | yes |
| **services-external**/cassandra | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **services-external**/clamav | :x: | no | no | yes | no | 0 | 0 | yes | no |
| **services-external**/clamav-simple | :white_check_mark: | no | no | yes | yes | 100 | 101 | yes | yes |
| **services-external**/clamav/clamd | :white_check_mark: | no | no | yes | yes | 100 | 101 | yes | yes |
| **services-external**/clamav/freshclam | :white_check_mark: | no | no | yes | yes | 100 | 101 | yes | yes |
| **services-external**/clamav/icap | :white_check_mark: | no | no | yes | yes | 100 | 101 | yes | yes |
| **services-external**/clamav/milter | :white_check_mark: | no | no | yes | yes | 100 | 101 | yes | yes |
| **services-external**/mariadb | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **services-external**/memcached | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **services-external**/minio | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **services-external**/opendesk-dkimpy-milter | :x: | yes | no | yes | yes | 1000 | 1000 | yes | no |
| **services-external**/postfix | :x: | yes | yes | yes | no | 0 | 0 | yes | no |
| **services-external**/postgresql | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **services-external**/redis/master | :white_check_mark: | no | no | yes | yes | 1001 | 1001 | yes | yes |
| **xwiki**/xwiki | :x: | no | no | no | yes | 100 | 101 | yes | yes |


This file is auto-generated by [openDesk CI CLI](https://gitlab.opencode.de/bmi/opendesk/tooling/opendesk-ci-cli)
