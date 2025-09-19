<!--
SPDX-FileCopyrightText: 2024-2025 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Updates & Upgrades</h1>

<!-- TOC -->
* [Disclaimer](#disclaimer)
* [Deprecation warnings](#deprecation-warnings)
* [Automated migrations - Overview and mandatory upgrade path](#automated-migrations---overview-and-mandatory-upgrade-path)
* [Manual checks/actions](#manual-checksactions)
  * [v1.6.0+](#v160)
    * [Pre-upgrade to v1.6.0+](#pre-upgrade-to-v160)
      * [Upstream contraint: Nubus' external secrets](#upstream-contraint-nubus-external-secrets)
      * [Helmfile new secret: `secrets.minio.openxchangeUser`](#helmfile-new-secret-secretsminioopenxchangeuser)
      * [Helmfile new object storage: `objectstores.openxchange.*`](#helmfile-new-object-storage-objectstoresopenxchange)
      * [OX App Suite fix-up: Using S3 as storage for non mail attachments (pre-upgrade)](#ox-app-suite-fix-up-using-s3-as-storage-for-non-mail-attachments-pre-upgrade)
    * [Post-upgrade to v1.6.0+](#post-upgrade-to-v160)
      * [OX App Suite fix-up: Using S3 as storage for non mail attachments (post-upgrade)](#ox-app-suite-fix-up-using-s3-as-storage-for-non-mail-attachments-post-upgrade)
  * [v1.4.0+](#v140)
    * [Pre-upgrade to v1.4.0+](#pre-upgrade-to-v140)
      * [Helmfile new feature: `functional.authentication.ssoFederation`](#helmfile-new-feature-functionalauthenticationssofederation)
      * [Helmfile cleanup: `global.additionalMailDomains` as list](#helmfile-cleanup-globaladditionalmaildomains-as-list)
  * [v1.2.0+](#v120)
    * [Pre-upgrade to v1.2.0+](#pre-upgrade-to-v120)
      * [Helmfile cleanup: Do not configure OX provisioning when no OX installed](#helmfile-cleanup-do-not-configure-ox-provisioning-when-no-ox-installed)
      * [Helmfile new default: PostgreSQL for XWiki and Nextcloud](#helmfile-new-default-postgresql-for-xwiki-and-nextcloud)
  * [v1.1.2+](#v112)
    * [Pre-upgrade to v1.1.2+](#pre-upgrade-to-v112)
      * [Helmfile feature update: App settings wrapped in `apps.` element](#helmfile-feature-update-app-settings-wrapped-in-apps-element)
  * [v1.1.1+](#v111)
    * [Pre-upgrade to v1.1.1](#pre-upgrade-to-v111)
      * [Helmfile feature update: Component specific `storageClassName`](#helmfile-feature-update-component-specific-storageclassname)
      * [Helmfile new secret: `secrets.nubus.masterpassword`](#helmfile-new-secret-secretsnubusmasterpassword)
  * [v1.1.0+](#v110)
    * [Pre-upgrade to v1.1.0](#pre-upgrade-to-v110)
      * [Helmfile cleanup: Restructured `/helmfile/files/theme` folder](#helmfile-cleanup-restructured-helmfilefilestheme-folder)
      * [Helmfile cleanup: Consistent use of `*.yaml.gotmpl`](#helmfile-cleanup-consistent-use-of-yamlgotmpl)
      * [Helmfile cleanup: Prefixing certain app directories with `opendesk-`](#helmfile-cleanup-prefixing-certain-app-directories-with-opendesk-)
      * [Helmfile cleanup: Splitting external services and openDesk services](#helmfile-cleanup-splitting-external-services-and-opendesk-services)
      * [Helmfile cleanup: Streamlining `openxchange` and `oxAppSuite` attribute names](#helmfile-cleanup-streamlining-openxchange-and-oxappsuite-attribute-names)
      * [Helmfile feature update: Dicts to define `customization.release`](#helmfile-feature-update-dicts-to-define-customizationrelease)
      * [openDesk defaults (new): Enforce login](#opendesk-defaults-new-enforce-login)
      * [openDesk defaults (changed): Jitsi room history enabled](#opendesk-defaults-changed-jitsi-room-history-enabled)
      * [External requirements: Redis 7.4](#external-requirements-redis-74)
    * [Post-upgrade to v1.1.0+](#post-upgrade-to-v110)
      * [XWiki fix-ups](#xwiki-fix-ups)
  * [v1.1.0](#v110-1)
    * [Pre-upgrade to v1.1.0](#pre-upgrade-to-v110-1)
      * [Configuration Cleanup: Removal of unnecessary OX-Profiles in Nubus](#configuration-cleanup-removal-of-unnecessary-ox-profiles-in-nubus)
      * [Configuration Cleanup: Updated `global.imagePullSecrets`](#configuration-cleanup-updated-globalimagepullsecrets)
      * [Changed openDesk defaults: Matrix presence status disabled](#changed-opendesk-defaults-matrix-presence-status-disabled)
      * [Changed openDesk defaults: Matrix ID](#changed-opendesk-defaults-matrix-id)
      * [Changed openDesk defaults: File-share configurability](#changed-opendesk-defaults-file-share-configurability)
      * [Changed openDesk defaults: Updated default subdomains in `global.hosts`](#changed-opendesk-defaults-updated-default-subdomains-in-globalhosts)
      * [Changed openDesk defaults: Dedicated group for access to the UDM REST API](#changed-opendesk-defaults-dedicated-group-for-access-to-the-udm-rest-api)
    * [Post-upgrade to v1.0.0+](#post-upgrade-to-v100)
      * [Configuration Improvement: Separate user permission for using Video Conference component](#configuration-improvement-separate-user-permission-for-using-video-conference-component)
      * [Optional Cleanup](#optional-cleanup)
* [Automated migrations - Details](#automated-migrations---details)
  * [v1.6.0+ (automated)](#v160-automated)
    * [v1.6.0+ migrations-post](#v160-migrations-post)
  * [v1.2.0+ (automated)](#v120-automated)
    * [v1.2.0+ migrations-pre](#v120-migrations-pre)
    * [v1.2.0+ migrations-post](#v120-migrations-post)
  * [v1.1.0+ (automated)](#v110-automated)
  * [v1.0.0+ (automated)](#v100-automated)
  * [Related components and artifacts](#related-components-and-artifacts)
  * [Development](#development)
<!-- TOC -->

# Disclaimer

Starting with openDesk 1.0, we aim to offer hassle-free updates/upgrades.

Therefore, openDesk contains automated migrations between versions which reduces the need for manual interaction.

These automated migrations have limitations in the sense that they require a certain openDesk version to be installed, effectively resulting in a forced upgrade path. This is highlighted in the section [Automated migrations](#automated-migrations).

Manual checks and possible activities are also required by openDesk updates, they are described in the section [Manual update steps](#manual-update-steps).

> **Note**<br>
> Please be sure to _thoroughly_ read / follow the requirements before you update / upgrade.

> **Known limitations**<br>
> We assume that the PV reclaim policy is set to `delete`, resulting in PVs getting deleted as soon as the related PVC is deleted; we will not address explicit deletion for PVs.

# Deprecation warnings

We cannot hold back all migrations as some are required e.g. due to a change in a specific component that we want/need to update, we try to bundle others only with major releases.

This section should provide you with an overview of what changes to expect in the next major release (openDesk 2.0) expected in September 2025.

- `functional.portal.link*` (see `functional.yaml.gotmpl` for details) are going to be moved into the `theme.*` tree, we are also going to move the icons used for the links currently found under `theme.imagery.portalEntries` in this step.
- We will explicitly set the [database schema configuration](https://www.xwiki.org/xwiki/bin/view/Documentation/AdminGuide/Configuration/#HConfigurethenamesofdatabaseschemas) for XWiki to avoid the use of the `public` schema.

# Automated migrations - Overview and mandatory upgrade path

The following table gives an overview of the mandatory upgrade path of openDesk, required in order for the automated migrations to work as expected.

To upgrade existing deployments, you cannot skip any version mentioned in the column *Mandatory version*. When a version number is not fully defined (e.g. `v1.1.x`), you can install any version matching that constraint.

| Mandatory version |
| ----------------- |
<!-- | 1.x.x        |  add the entry to the table as soon as we get new migration requiring that the former migration was executed -->
| v1.5.0            |
| v1.1.x            |
| v1.0.0            |
| v0.9.0            |
| v0.8.1            |

> **Note**<br>
> Be sure to check out the table in the release version you are going to install, and not the currently installed version.

If you would like more details about the automated migrations, please read section [Automated migrations - Details](#automated-migrations---details).

# Manual checks/actions

## v1.6.0+

### Pre-upgrade to v1.6.0+

#### Upstream contraint: Nubus' external secrets

**Target group:** Operators that use external secrets for Nubus.

> **Note**<br>
> External Secrets are not yet a supported feature. We are working on making it available in 2025, though it is possible to make use of the support for external secrets within single applications using the openDesk [customization](../helmfile/environments/default/customization.yaml.gotmpl) options.

Please ensure you read the [Nubus 1.10.0 "Migration steps" section](https://docs.software-univention.de/nubus-kubernetes-release-notes/1.x/en/changelog.html#v1-10-0-migration-steps) with focus on the paragraph "Operators that make use of the following UDM Listener secrets variables" and act accordingly.

#### Helmfile new secret: `secrets.minio.openxchangeUser`

**Target group:** All existing deployments that have OX App Suite enabled and that use externally defined secrets in combination with openDesk provided MinIO object storage.

For OX App Suite to access the object storage a new secret has been introduced.

It is declared in [`secrets.yaml.gotmpl`](../helmfile/environments/default/secrets.yaml.gotmpl) by the key: `secrets.minio.openxchangeUser`. If you define your own secrets, please ensure that you provide a value for this secret as well, otherwise the aforementioned secret will be derived from the `MASTER_PASSWORD`.

#### Helmfile new object storage: `objectstores.openxchange.*`

**Target group:** All deployments that use an external object storage.

For OX App Suite's newly introduced filestore you have to configure a new object storage (bucket). When you are using
an external object storage you did this already for all the entries in
[`objectstores.yaml.gotmpl`](../helmfile/environments/default/objectstores.yaml.gotmpl). Where we now introduced
`objectstores.openxchange` section that you also need to provide you external configuration for.

#### OX App Suite fix-up: Using S3 as storage for non mail attachments (pre-upgrade)

**Target group:** All existing deployments that have OX App Suite enabled.

With openDesk 1.6.0 OX App Suite persists the attachments on contact, calendar or task objects in object storage.

To enable the use of this new filestore backend existing deployments must execute the following steps.

Preparation:
- Ensure your `kubeconfig` is pointing to the cluster that is running your deployment.
- Identify/create a e.g. local temporary directory that can keep the attachments while upgrading openDesk.
- Set some environment variables to prepare running the documented commands:

```shell
export ATTACHMENT_TEMP_DIR=<your_temporary_directory_for_the_attachments>
export NAMESPACE=<your_namespace>
```

1. Copy the existing attachments from all `open-xchange-core-mw-default-*` Pods to the identified directory, example for `open-xchange-core-mw-default-0`:
```shell
kubectl cp -n ${NAMESPACE} open-xchange-core-mw-default-0:/opt/open-xchange/ox-filestore ${ATTACHMENT_TEMP_DIR}
```
2. Run the upgrade.
3. Continue with the [related post-upgrade steps](#ox-app-suite-fix-up-using-s3-as-storage-for-non-mail-attachments-post-upgrade)

### Post-upgrade to v1.6.0+

#### OX App Suite fix-up: Using S3 as storage for non mail attachments (post-upgrade)

**Target group:** All existing deployments having OX App Suite enabled.

Continued from the [related pre-upgrade section](#ox-app-suite-fix-up-using-s3-as-storage-for-non-mail-attachments-pre-upgrade).

1. Copy the attachments back from your temporary directory into `open-xchange-core-mw-default-0`.
```shell
kubectl cp -n ${NAMESPACE} ${ATTACHMENT_TEMP_DIR}/* open-xchange-core-mw-default-0:/opt/open-xchange/ox-filestore
```
2. Ideally you verify the files have been copied as expected checking the target directory in the `open-xchange-core-mw-default-0` Pod. All the following commands are for execution within the aforementioned Pod.
3. Get the `id` of the new object storage based OX filestore, using the following command in the first line of the following block. In the shown example output the `id` for the new filestore would be `10` as the filestore can be identified by its path value `s3://ox-filestore-s3`, the `id` of the existing filestore would be `3` identified by the corresponding path `/opt/open-xchange/ox-filestore`:
```shell
/opt/open-xchange/sbin/listfilestore -A $MASTER_ADMIN_USER -P $MASTER_ADMIN_PW
id path                             size reserved used max-entities cur-entities
 3 /opt/open-xchange/ox-filestore 100000      200    5         5000            1
10 s3://ox-filestore-s3           100000        0    0         5000            0
```
4. Get the list of your OX contexts IDs (`cid` column in the output of the `listcontext` command), as the next step needs to be executed per OX context. Most installation will just have a single OX context (`1`).
```shell
/opt/open-xchange/sbin/listcontext -A $MASTER_ADMIN_USER -P $MASTER_ADMIN_PW
cid fid fname       enabled qmax qused name lmappings
  1   3 1_ctx_store true             5 1    1,context1
```
5. For each of your OX contexts IDs run the final filestore migration command and you will get output like this: `context 1 to filestore 10 scheduled as job 1`:
```shell
/opt/open-xchange/sbin/movecontextfilestore -A $MASTER_ADMIN_USER -P $MASTER_ADMIN_PW -f <your_s3_filestore_id_from_step_3> -c <your_context_id_from_step_4>
```
6. Depending on the size of your filestore, moving the contexts will take some time. You can check the status of a context's jobs with the command below. When the job status is `Done` you can also doublecheck that everything worked as expected by running the `listfilestore` command from step #3 and should see that the filestore is no longer used.
```shell
/opt/open-xchange/sbin/jobcontrol -A $MASTER_ADMIN_USER -P $MASTER_ADMIN_PW -c <your_context_id_from_step_4> -l
ID    Type of Job                              Status     Further Information
1     movefilestore                            Done       move context 1 to filestore 10
```
7. Finally you can unregister the old filestore:
```shell
/opt/open-xchange/sbin/unregisterfilestore -A $MASTER_ADMIN_USER -P $MASTER_ADMIN_PW -i <your_old_filestore_id_from_step_3>
```

## v1.4.0+

### Pre-upgrade to v1.4.0+

#### Helmfile new feature: `functional.authentication.ssoFederation`

**Target group:** Deployments that make use of IdP federation as described in [`idp-federation.md`](./enhanced-configuration/idp-federation.md).

Please ensure to configure your IdP federation config details as part of `functional.authentication.ssoFederation`. You can find more details in the "Example configuration" section of [`idp-federation.md`](./enhanced-configuration/idp-federation.md).

#### Helmfile cleanup: `global.additionalMailDomains` as list

**Target group:** Installations that have set `global.additionalMailDomains`.

The `additionalMailDomains` had to be defined as a comma separated string. That now needs to change into a list of domains.

For example the following config:

```yaml
global:
  additionalMailDomains: "sub1.maildomain.de,sub2.maildomain.de"
```

Needs to change to:

```yaml
global:
  additionalMailDomains:
    - "sub1.maildomain.de"
    - "sub2.maildomain.de"
```

## v1.2.0+

### Pre-upgrade to v1.2.0+

#### Helmfile cleanup: Do not configure OX provisioning when no OX installed

**Target group:** Installations that have no OX App Suite installed.

With openDesk 1.2.0 the OX provisioning consumer will not be registered when there is no OX installed.

We do not remove the consumer for existing installations, if you want to do that for your existing installation please perform the following steps:

```shell
export NAMESPACE=<your_namespace>
kubectl -n ${NAMESPACE} exec -it ums-provisioning-nats-0 -c nats-box -- sh -c 'nats consumer rm stream:ox-connector durable_name:ox-connector --user=admin --password=${NATS_PASSWORD} --force'
kubectl -n ${NAMESPACE} exec -it ums-provisioning-nats-0 -c nats-box -- sh -c 'nats stream rm stream:ox-connector --user=admin --password=${NATS_PASSWORD} --force'
kubectl -n ${NAMESPACE} delete secret ums-provisioning-ox-credentials-test
```

#### Helmfile new default: PostgreSQL for XWiki and Nextcloud

**Target group:** All upgrade installations that do not already use the previous optional PostgreSQL database backend for Nextcloud and XWiki.

openDesk now uses PostgreSQL as default database backend for Nextcloud and XWiki.

When upgrading existing instances you likely want to keep the current database backend (MariaDB).

**Use case A:** You use your own external database services, if not see "Use case B" further down.

You just have to add the new `type` attribute and set it to `mariadb`:

```yaml
databases:
  nextcloud:
    type: "mariadb"
  xwiki:
    type: "mariadb"
```

**Use case B:** You use the openDesk supplied database services.

Ensure you set the following attributes before upgrading, this includes the aforementioned `type` attribute.

```yaml
databases:
  nextcloud:
    type: "mariadb"
    host: "mariadb"
    port: 3306
  xwiki:
    type: "mariadb"
    host: "mariadb"
    port: 3306
    username: "root"
```

In case you are planning to migrate an existing instance from MariaDB to PostgreSQL please check the upstream documentation for details:

- Nextcloud database migration: https://docs.nextcloud.com/server/latest/admin_manual/configuration_database/db_conversion.html
- XWiki:
  - https://www.xwiki.org/xwiki/bin/view/Documentation/AdminGuide/Backup#HUsingtheXWikiExportfeature
  - https://www.xwiki.org/xwiki/bin/view/Documentation/AdminGuide/ImportExport

## v1.1.2+

### Pre-upgrade to v1.1.2+

#### Helmfile feature update: App settings wrapped in `apps.` element

We now require [Helmfile v1.0.0-rc.8](https://github.com/helmfile/helmfile/releases/tag/v1.0.0-rc.8) for the deployment. This enables openDesk to lay the foundation for some significant cleanups where the information from the different apps, especially their `enabled` state, is needed.

Therefore, it was necessary to introduce the `apps` level in [`opendesk_main.yaml.gotmpl`](../helmfile/environments/default/opendesk_main.yaml.gotmpl).

If you have a deployment where you specify settings found in the aforementioned file, specifically to disable or enable components, please ensure you insert the top-level attribute `apps` as shown in the following example.

The following configuration:

```yaml
certificates:
  enabled: false
notes:
  enabled: true
```

Needs to be changed to:

```yaml
apps:
  certificates:
    enabled: false
  notes:
    enabled: true
```

## v1.1.1+

### Pre-upgrade to v1.1.1

#### Helmfile feature update: Component specific `storageClassName`

With openDesk 1.1.1 we support component specific `storageClassName` definitions beside the global ones. For this, we had to adapt the structure found in `persistence.yaml.gotmpl` to achieve this in a clean manner.

If you have set custom `persistence.size.*`-values for your deployment, please continue reading as you need to adapt your `persistence` settings to the new structure.

When comparing the [old v1.1.0 structure](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/v1.1.0/helmfile/environments/default/persistence.yaml.gotmpl) with the [new one](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/v1.1.1/helmfile/environments/default/persistence.yaml.gotmpl), you will spot these changes:

- We replaced `persistence.size` with `persistence.storages`.
- Below each component you can define now the `size` and the optional component specific `storageClassName`.
- We streamlined the structure of the components by placing them on the same level, as beforehand, Nubus had an additional level of nesting.

The following configuration:

```yaml
persistence:
  size:
    synapse: "1Gi"
```

Needs to be changed to:

```yaml
persistence:
  storages:
    synapse:
      size: "1Gi"
```

Or for the Nubus related entries, the following:

```yaml
persistence:
  size:
    nubus:
      ldapServerData: "1Gi"
```

Needs to be changed to:

```yaml
persistence:
  storages:
    nubusLdapServerData:
      size: "1Gi"
```

#### Helmfile new secret: `secrets.nubus.masterpassword`

A not yet templated secret was discovered in the Nubus deployment. It is now declared in [`secrets.yaml.gotmpl`](../helmfile/environments/default/secrets.yaml.gotmpl) and can be defined using: `secrets.nubus.masterpassword`. If you define your own secrets, please be sure this new secret is set to the same value as the `MASTER_PASSWORD` environment variable used in your deployment.

## v1.1.0+

### Pre-upgrade to v1.1.0

#### Helmfile cleanup: Restructured `/helmfile/files/theme` folder

If you make use of the [theme folder](../helmfile/files/theme/) or the [`theme.yaml.gotmpl`](../helmfile/environments/default/theme.yaml.gotmpl), e.g. to apply your own imagery, please ensure you adhere to the new structure of the folder and the yaml-file.

#### Helmfile cleanup: Consistent use of `*.yaml.gotmpl`

In v1.0.0 the files in [`/helmfile/environments/default`](../helmfile/environments/default/) had mixed file extensions.
Now we have streamlined this and consistently use the `*.yaml.gotmpl` file extension.

This change likely requires manual action in two situations:

1. You are referencing our upstream files from the aforementioned directory, e.g. in your Argo CD deployment. If so, please update your references to use the filenames with the new extension.
2. You have custom files containing configuration information that are simply named `*.yaml`. If so, please rename them to `*.yaml.gotmpl`.

#### Helmfile cleanup: Prefixing certain app directories with `opendesk-`

To make it more obvious that some elements from within the [`apps`](../helmfile/apps/) directory are solely
provided by openDesk, we have prefixed these app directories with `opendesk-`.

Affected are the following directories, here listed directly with the new prefix:

- [`./helmfile/apps/opendesk-migrations-pre`](../helmfile/apps/opendesk-migrations-pre)
- [`./helmfile/apps/opendesk-migrations-post`](../helmfile/apps/opendesk-migrations-post)
- [`./helmfile/apps/opendesk-openproject-bootstrap`](../helmfile/apps/opendesk-openproject-bootstrap)

The described changes most likely require manual action in the following situation:

- You are referencing our upstream files e.g. in your Argo CD deployment. If so, please update your references to use the new directory names.

#### Helmfile cleanup: Splitting external services and openDesk services

In v1.0.0 there was a directory `/helmfile/apps/services` that was intended to contain all the services an operator had to provide externally for production deployments.

As some services that are actually part of openDesk snuck in there, we had to split the directory into two separate ones:

- [`./helmfile/apps/opendesk-services`](../helmfile/apps/opendesk-services)
- [`./helmfile/apps/services-external`](../helmfile/apps/services-external)

The described changes most likely require manual action in the following situation:

- You are referencing our upstream files e.g. in your Argo CD deployment. If so, please update your references to use the new directory names.

#### Helmfile cleanup: Streamlining `openxchange` and `oxAppSuite` attribute names

We have updated some attribute names within the Open-Xchange / OX App Suite to be consistent within our Helmfile
deployment. This change also aligns us with the actual brand names, as well as our rule of thumb for brand based
attribute names[^1].

In case you are using any of the customizations below, the (`WAS`) values, please update to the (`NOW`) values:

```
WAS: oxAppsuite: ...
NOW: oxAppSuite: ...
```

```
WAS: cache.oxAppsuite: ...
NOW: cache.oxAppSuite: ...
```

```
WAS: charts.openXchangeAppSuite: ...
NOW: charts.oxAppSuite: ...
```

```
WAS: charts.openXchangeAppSuiteBootstrap: ...
NOW: charts.oxAppSuiteBootstrap: ...
```

```
WAS: customization.release.openXchange: ...
NOW: customization.release.openxchange: ...
```

```
WAS: customization.release.opendeskOpenXchangeBootstrap: ...
NOW: customization.release.opendeskOpenxchangeBootstrap: ...
```

```
WAS: databases.oxAppsuite: ...
NOW: databases.oxAppSuite: ...
```

```
WAS: ingress.parameters.openXchangeAppSuite: ...
NOW: ingress.parameters.oxAppSuite: ...
```

```
WAS: ingress.bodyTimeout.openXchangeAppSuite: ...
NOW: ingress.bodyTimeout.oxAppSuite: ...
```

```
WAS: migration.oxAppsuite: ...
NOW: migration.oxAppSuite: ...
```

```
WAS: secrets.oxAppsuite: ...
NOW: secrets.oxAppSuite: ...
```

#### Helmfile feature update: Dicts to define `customization.release`

If you make use of the `customization.release` option, you have to switch to a dictionary based definition of customization files, for example:

The following:

```yaml
customization:
  release:
    collaboraOnline: "./my_custom_templating.yaml.gotmpl"
```

Needs to be changed to:

```yaml
customization:
  release:
    collaboraOnline:
      file1: "./my_custom_templating.yaml.gotmpl"
```

You can freely choose the `file1` dictionary key used in the example above, but it should start with a letter.

#### openDesk defaults (new): Enforce login

Users accessing the openDesk portal are now automatically redirected to the login screen per default.

In case you want to keep the previous behavior you need to set the following `functional` flag:

```yaml
functional:
  portal:
    enforceLogin: false
```

#### openDesk defaults (changed): Jitsi room history enabled

The default to store the Jitsi room history in the local storage of a user's browser has changed.

It is now enabled and therefore stored by default.

To preserve the v1.0.0 behavior of not storing the room history you have to explicitly configure it:

```yaml
functional:
  dataProtection:
    jitsiRoomHistory:
      enabled: false
```

#### External requirements: Redis 7.4

The update from openDesk v1.0.0 contains Redis 7.4.1, like the other openDesk bundled services, the bundled Redis is not meant to be used in production.

Please ensure the Redis you are using is updated to at least version 7.4 to support the requirement of OX App Suite.

### Post-upgrade to v1.1.0+

#### XWiki fix-ups

Unfortunately XWiki does not upgrade itself as expected. The bug has been reported and the supplier is aware. The following additional steps are required:

1. To enforce re-indexing of the now fixed full-text search, access the XWiki Pod and run the following commands to delete two search related directories:
   ```
   rm -rf /usr/local/xwiki/data/store/solr/search_9
   rm -rf /usr/local/xwiki/data/cache/solr/search_9
   ```
> The pod will need to be restarted for the changes to take effect.

2. This is necessary if the openDesk single sign-on no longer works, and you get a standard XWiki login dialogue instead:
   - Find the XWiki ConfigMap `xwiki-init-scripts` and locate in the `entrypoint` key the lines beginning with `xwiki_replace_or_add "/usr/local/xwiki/data/xwiki.cfg"`
   - Before those lines, add the following line while setting `<YOUR_TEMPORARY_SUPERADMIN_PASSWORD>` to a value you are happy with:
     ```
         xwiki_replace_or_add "/usr/local/xwiki/data/xwiki.cfg" 'xwiki.superadminpassword' '<YOUR_TEMPORARY_SUPERADMIN_PASSWORD>'
     ```
   - Restart the XWiki Pod.
   - Access XWiki's web UI and login with `superadmin` and the password you set above.
   - Once XWiki UI is fully rendered, remove the line with the temporary `superadmin` password from the aforementioned ConfigMap.
   - Restart the XWiki Pod.

You should have now a fully functional XWiki instance with single sign-on and full-text search.

## v1.1.0

### Pre-upgrade to v1.1.0

#### Configuration Cleanup: Removal of unnecessary OX-Profiles in Nubus

> **Warning**<br>
> The upgrade will fail if you do not address this section in your current deployment.

The update will remove unnecessary OX-Profiles in Nubus, so long as these profiles are in use.

So please ensure that only the following two supported profiles are assigned to your users:
- `opendesk_standard`: "opendesk Standard"
- `none`: "Login disabled"

You can review and update other accounts as follows:
- Login as IAM admin.
- Open the user module.
- Open the extended search by clicking the funnel (DE: "Trichter") icon next to the search input field.
- Open the "Property" (DE: "Eigenschaft") list and select "OX Access" (DE: "OX-Berechtigung").
- Enter an asterisk (*) in the input field next to the list.
- Start the search by clicking once more on the funnel icon.
- Sort the result list for the "OX Access" column.
- Edit every user that has a value different to `opendesk_standard` or `none`:
  - Open the user.
  - Go to section "OX App Suite".
  - Change the value in the dropdown "OX Access" to either:
    - "openDesk Standard" if the user should be able to use the Groupware module.
    - "Login disabled" if the user should not use the Groupware module.
  - Update the user account with the green "SAVE" button at the top of the page.

#### Configuration Cleanup: Updated `global.imagePullSecrets`

Without using a custom container image registry, you can pull all the openDesk images without authentication.
Thus defining non-existent imagePullSecrets creates unnecessary errors, so we removed them.

You can keep the current settings by setting the `external-registry` in your custom environment values:

```yaml
global:
  imagePullSecrets:
    - "external-registry"
```

#### Changed openDesk defaults: Matrix presence status disabled

Show other user's Matrix presence status is now disabled by default to comply with data protection requirements.

To enable it or keep the v0.9.0 default, please set:

```yaml
functional:
  dataProtection:
    matrixPresence:
      enabled: true
```

#### Changed openDesk defaults: Matrix ID

Until v0.9.0 openDesk used the LDAP entryUUID of a user to generate the user's Matrix ID. Due to restrictions of the
Matrix protocol, an update to a Matrix ID is not possible. Therefore, it was technically convenient to use the UUID
as they are immutable (see https://en.wikipedia.org/wiki/Universally_unique_identifier for more details on UUIDs.)

From the user experience perspective, that was a flawed approach, so from openDesk 1.0 onwards, by default, the openDesk login username is used to define the `localpart` of the Matrix ID.

For existing installations: The changed setting only affects users who log in to Element for the first time. Existing
user accounts will not be harmed. If you want existing users to get new Matrix IDs based on the new setting, you
must update their external ID in Synapse and deactivate the old user afterward. The user will get a completely new
Matrix account, losing their existing contacts, chats, and rooms.

The following Admin API calls are helpful:
- `GET /_synapse/admin/v2/users/@<entryuuid>:<matrixdomain>` get the user's existing external_id (auth_provider: "oidc")
- `PUT /_synapse/admin/v2/users/@<entryuuid>:<matrixdomain>` update user's external_id with JSON payload:
  `{ "external_ids": [ { "auth_provider": "oidc", "external_id": "<old_id>+deprecated" } ] }`
- `POST /_synapse/admin/v1/deactivate/@<entryuuid>:<matrixdomain>` deactivate old user with JSON payload:
  `{ "erase": true }`

For more details, check the Admin API documentation:
https://element-hq.github.io/synapse/latest/usage/administration/admin_api/index.html

You can enforce the old standard with the following setting:
```yaml
functional:
 chat:
   matrix:
     profile:
       useImmutableIdentifierForLocalpart: true
```

#### Changed openDesk defaults: File-share configurability

We now provide some configurability regarding the sharing capabilities of the Nextcloud component.

See the settings under `functional.filestore` in [functional.yaml](../helmfile/environments/default/functional.yaml).

For the following settings, the default in openDesk 1.0 has changed, so you might want to update
the settings for your deployment to keep its current behavior:

```yaml
functional:
 filestore:
   sharing:
     external:
       enabled: true
       expiry:
         activeByDefault: false
```

#### Changed openDesk defaults: Updated default subdomains in `global.hosts`

We have streamlined the subdomain names in openDesk to be more user-friendly and to avoid the use of specific
product names.

This results in the following changes to the default subdomain naming:

- **collabora**: `collabora` → `office`
- **cryptpad**: `cryptpad` → `pad`
- **minioApi**: `minio` → `objectstore`
- **minioConsole**: `minio-console` → `objectstore-ui`
- **nextcloud**: `fs` → `files`
- **openproject**: `project` → `projects`

Existing deployments should keep the old subdomains because URL/link changes are not supported through all components.

If you have not already defined the entire `global.hosts` dictionary in your custom environments values, please set it
to the defaults that were used before the upgrade:

```yaml
global:
  hosts:
    collabora: "collabora"
    cryptpad: "cryptpad"
    element: "chat"
    intercomService: "ics"
    jitsi: "meet"
    keycloak: "id"
    matrixNeoBoardWidget: "matrix-neoboard-widget"
    matrixNeoChoiceWidget: "matrix-neochoice-widget"
    matrixNeoDateFixBot: "matrix-neodatefix-bot"
    matrixNeoDateFixWidget: "matrix-neodatefix-widget"
    minioApi: "minio"
    minioConsole: "minio-console"
    nextcloud: "fs"
    openproject: "project"
    openxchange: "webmail"
    synapse: "matrix"
    synapseFederation: "matrix-federation"
    univentionManagementStack: "portal"
    whiteboard: "whiteboard"
    xwiki: "wiki"
```

In case you would like to update an existing deployment to use the new hostnames, you would be doing so at your own risk, so please consider the following:

- Some of your user's bookmarks and links will stop working.
- Portal links will get updated automatically.
- The update of the OpenProject <-> Nextcloud file integration needs to be updated manually as follows:
  - Use an account with functional admin permissions for both Nextcloud and OpenProject
  - In Nextcloud: *Administration* > *Files* > *External file storages* > Select `Nextcloud at [your_domain]`
    - Edit *Details* - *General Information* - *Storage provider* and update the *hostname* to `files.<your_domain>`
  - In OpenProject: *Administration* > *OpenProject* > *OpenProject server*
    - Update the *OpenProject host* to `projects.<your_domain>`

#### Changed openDesk defaults: Dedicated group for access to the UDM REST API

Prerequisite: You allow the use of the [IAM's API](https://docs.software-univention.de/developer-reference/5.0/en/udm/rest-api.html)
with the following setting:

```yaml
functional:
  externalServices:
    nubus:
      udmRestApi:
        enabled: true
```

With v0.9.0, all members of the group "Domain Admins" could successfully authenticate with the API.

With openDesk 1.0, we introduced a specific group for permission to use the API: `IAM API - Full Access`.

The IAM admin account `Administrator` is the only member of this group by default.

If you need other accounts to use the API, please assign them to the aforementioned group.

### Post-upgrade to v1.0.0+

#### Configuration Improvement: Separate user permission for using Video Conference component

With openDesk 1.0 the user permission for authenticated access to the Chat and Video Conference components was split into two separate permissions.

Therefore, the newly added *Video Conference* permission has to be added to users that should have continued access to the component.

This can be done as IAM admin:
- Open the *user* module.
- Select all users that should get the permission for *Video Conference* using the checkbox left of the users' entry.
- In top bar of the user table click on *Edit*.
- Select the *openDesk* section from the left-hand menu.
- Check the checkbox for *Video Conference* and the directly below check box for *Overwrite*.
- Click on the green *Save* button at the top of the screen to apply the change.

> **Hint**<br>
> If you have a lot of users and want to update (almost) all them, you can select all users by clicking the checkbox in the user's table header and then de-selecting the users you do not want to update.

#### Optional Cleanup

We do not execute possible cleanup steps as part of the migrations POST stage. So you might want to remove the unclaimed PVCs after a successful upgrade:

```shell
NAMESPACE=<your_namespace>
kubectl -n ${NAMESPACE} delete pvc shared-data-ums-ldap-server-0
kubectl -n ${NAMESPACE} delete pvc shared-run-ums-ldap-server-0
kubectl -n ${NAMESPACE} delete pvc ox-connector-ox-contexts-ox-connector-0
```

# Automated migrations - Details

## v1.6.0+ (automated)

> **Note**<br>
> Details can be found in [run_5.py](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-migrations/-/blob/main/odmigs-python/odmigs_runs/run_5.py).

### v1.6.0+ migrations-post

Restarting the StatefulSets `ums-provisioning-nats` and `ox-connector` due to a workaround applied on the NATS secrets, see the "Notes" segment of the ["Password seed" heading in getting-started.md](./docs/getting-started.md#password-seed)

> **Note**<br>
> This change aims to prevent authentication failures with NATS in some Pods, which can lead to errors such as: `wait-for-nats Unavailable, waiting 2 seconds. Error: nats: 'Authorization Violation'`.

## v1.2.0+ (automated)

> **Note**<br>
> Details can be found in [run_4.py](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-migrations/-/blob/main/odmigs-python/odmigs_runs/run_4.py).

### v1.2.0+ migrations-pre

- Delete PVC `group-membership-cache-ums-portal-consumer-0`: With the upgrade the Nubus Portal Consumer no longer requires to be executed with root privileges. The PVC contains files that require root permission to access them, therefore the PVC gets deleted (and re-created) during the upgrade.
- Delete StatefulSet `ums-portal-consumer`: A bug was fixed in the templating of the Portal Consumer's PVC causing the values in `persistence.storages.nubusPortalConsumer.*` to be ignored. As these values are immutable, we had to delete the whole StatefulSet.

### v1.2.0+ migrations-post

- Restarting Deployment `ums-provisioning-udm-transformer` and StatefulSet `ums-provisioning-udm-listener` as well as deleting the Nubus Provisioning consumer `durable_name:incoming` on stream `stream:incoming`: Due to a bug in Nubus 1.7.0 the `incoming` stream was blocked after the upgrade, the aforementioned measures unblock the stream.

## v1.1.0+ (automated)

With openDesk v1.1.0 the IAM stack supports HA LDAP primary as well as scalable LDAP secondary pods.

openDesk's automated migrations takes care of this upgrade requirement described here for
[Nubus 1.5.1](https://docs.software-univention.de/nubus-kubernetes-release-notes/1.5.1/en/changelog.html#migrate-existing-ldap-server-to-mirror-mode-readiness),
creating the config map with the mentioned label.

> **Note**<br>
> Details can be found in [run_3.py](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-migrations/-/blob/main/odmigs-python/odmigs_runs/run_3.py).

## v1.0.0+ (automated)

The `migrations-pre` and `migrations-post` jobs in the openDesk deployment address the automated migration tasks.

The permissions required to execute the migrations can be found in the migration's Helm chart [`role.yaml'](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/charts/opendesk-migrations/-/blob/v1.3.5/charts/opendesk-migrations/templates/role.yaml?ref_type=tags#L29).

> **Note**<br>
> Details can be found in [run_2.py](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-migrations/-/blob/main/odmigs-python/odmigs_runs/run_3.py).

## Related components and artifacts

openDesk comes with two upgrade steps as part of the deployment; they can be found in the folder [/helmfile/apps](../helmfile/apps/) along with all other components:

- `migrations-pre`: Is the very first app that gets deployed.
- `migrations-post`: Is the last app that gets deployed.

Both migrations must be deployed exclusively at their first/last position and not parallel with other components.

The status of the upgrade migrations is tracked in the ConfigMap `migrations-status`, more details can be found in the [README.md of the related container image](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-migrations/README.md).

## Development

When a new upgrade migration is required, ensure to address the following list:

- Update the generated release version file [`global.generated.yaml.gotmpl`](../helmfile/environments/default/global.generated.yaml.gotmpl) at least on the patch level to test the upgrade in your feature branch and trigger it in the `develop` branch after the feature branch was merged. During the release process, the value is overwritten by the release's version number.
- You have to implement the migration logic as a runner script in the [`opendesk-migrations`](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-migrations) image. Please find more instructions in the linked repository.
- You most likely have to update the [`opendesk-migrations` Helm chart](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/charts/opendesk-migrations) within the `rules` section of the [`role.yaml`](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/charts/opendesk-migrations/-/blob/main/charts/opendesk-migrations/templates/role.yaml) to provide the permissions required for the execution of your migration's logic.
- You must set the runner's ID you want to execute in the [migrations.yaml.gotmpl](../helmfile/shared/migrations.yaml.gotmpl). See also the `migrations.*` section of [the Helm chart's README.md](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/charts/opendesk-migrations/-/blob/main/charts/opendesk-migrations/README.md).
- Update the [`charts.yaml.gotmpl`](../helmfile/environments/default/charts.yaml.gotmpl) and [`images.yaml.gotmpl`](../helmfile/environments/default/images.yaml.gotmpl) to reflect the newer releases of the `opendesk-migrations` Helm chart and container image.

[^1]: We do not follow a brand name's specific spelling when it comes to upper and lower case and only use new word
uppercase when names consist of multiple, space divided words.
