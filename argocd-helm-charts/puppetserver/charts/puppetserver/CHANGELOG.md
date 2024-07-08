# Change Log

This file documents all notable changes to Puppet Server Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

NOTE: The change log until version `v0.2.4` is auto-generated.
## [v9.5.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.5.2) (2024-06-18)
- Fix: #233 - Allow puppetdb.fqdns.alternateServerNames to be configured

## [v9.5.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.5.1) (2024-05-09)
- Fix: #228 - fixed check for puppet certs in a multimaster setup

## [v9.5.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.5.0) (2024-05-09)
- Feat: ability to disable persistence of `var-dir` and `confd` volumes

## [v9.4.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.4.2) (2024-05-03)
- Fix: #215 fixed ability to use customconfigs with PuppetDB

## [v9.4.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.4.1) (2024-05-02)
- Feat: allow option to import CA to only deal with CA and not puppetdb

## [v9.4.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.4.0) (2024-04-19)
- Fix: Update Vox Pupuli Containers

## [v9.3.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.3.4) (2024-04-11)
- Fix: Bump bitnami/jmx-exporter to latest stable for container patches

## [v9.3.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.3.3) (2024-04-10)
- Fix: Update cURL container to address CVE-2023-38545 & CVE-2023-38546

## [v9.3.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.3.2) (2024-04-08)
- Fix: Fixes bug in puppet-preinstall template when puppetserver.preGeneratedCertsJob is enabled. 

## [v9.3.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.3.1) (2024-04-03)
- Fix: Fixes bug when viaHttps.customCa is not provided

## [v9.3.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.3.0) (2024-03-28)
- Feat: Use custom CA file for r10k HTTPS code repository

## [v9.2.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.2.1) (2024-03-27)
- Fix: Add 'netrc' credentials documentation for r10k and hiera repos

## [v9.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.2.0) (2024-04-05)
- Feat: Add `.Values.global.securityContext.fsGroup`
- Fix: Add `spec.template.spec.securityContext.fsGroup` to prevent "Permission denied" error

## [v9.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.1.0) (2024-01-31)
- Fix: Remove `PUPPETDB_JAVA_ARGS` value on puppetdb container additional variables, to avoid error `unrecognized option: -Xlog:gc....` that causes the puppetdb pod to crash.

## [v9.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v9.0.0) (2023-12-08)
- Breaking: Update values structure for 'metrics' to allow for multiple exporters
- Feat: Make serviceMonitor optional for all Prometheus exporters
- Feat: Add jmx exporter for puppetserver master(s)/compiler(s)
- Feat: Allow specifying annotations for puppetserver master/compiler and puppetdb pods
- Maint: Add snapshots to all unittests and over masters/compilers with them

## [v8.2.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.2.0) (2023-11-29)
- feat: GitHub Actions workflow: add lint, install and unittest for all PRs
- feat: GitHub Actions workflow: simplify workflow_dispatch to aid releases from forks

## [v8.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.2.0) (2023-11-27)
- Fix: Typo in compiler statefulset readiness probe scheme
- Fix: `PUPPETDB_JAVA_ARGS` which includes `-Xlog:gc:` instead of the deprecated `-Xloggc` and uses an existing path
- Fix: Broken r10k-code command for statefulset compilers & standardize r10k-code readiness probe usage
- Feat: Environment variables loaded from secret key-value pairs

## [v8.1.5](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.1.5) (2023-11-22)
- Fix: Typo in the restic backup template preventing chart from being deployed
- Feat: Add ability to mount custom ca-certificates.crt from configMap for Restic

## [v8.1.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.1.4) (2023-11-20)
- Fix: Utilize `puppetserver` and `puppetdb` containers provided by voxpupuli and bump default versions

## [v8.1.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.1.3) (2023-09-24)
- Fix: Wrong init value of r10k-code deployment readinessprobe

## [v8.1.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.1.2) (2023-08-16)
- Feat: allow parametrize readiness probe scheme

## [v8.1.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.1.1) (2023-07-13)
- Fix: correct readinessprobe syntax

## [v8.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v8.1.0) (2023-07-12)
- Feat: allows parametrized r10k code entrypoints

## [v7.4.5](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.4.5) (2023-06-28)
- Fix: r10k pod needs a script to run. Added all the needed mountpoint

## [v7.4.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.4.4) (2023-06-27)
- Fix: pgchecker doesn't work with external database. Added the possibility of setting external postgresql.hostname with .Values.puppetdb.extraEnv.PUPPETDB_POSTGRES_HOSTNAME

## [v7.4.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.4.3) (2023-05-10)
- Fix: puppet ca cronjob pvc claim name

## [v7.4.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.4.2) (2023-03-14)
- Fix: puppet master deployment issue when running as root

## [v7.4.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.4.1) (2023-02-17)
- Fix: Remove r10k & hiera configuration in preinstall job
- Fix: Preserve the whole tree file under /etc/puppetlabs/puppetserver when using the chart asNonRoot
- Fix: Add capability compatibility for Azure
- FIx: Manage hiera config in deployment to reload the pod automatically


## [v7.4.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.4.0) (2023-02-06)
- Feat: allow to `runAsNonRoot` puppetserver **deployement** (masters & compilers) pods
- Feat: add `PodDisruptionBudget`
- Feat: add `networkPolicy`
- Feat: allow to configure different affinity between masters & compilers
- Feat: no need to define manually the clusterIP of the puppetdb when using singleCA feature with public certificate authority
- Fix: Update `PodSecurityPolicy`, add missing `allowedCapabilities`
- Fix: puppetserver restart issue because of certificate name
- Fix: error in puppetserver log about `dropsonde`

## [v7.3.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.3.1) (2023-02-07)
- Fix: remove duplicate labels on puppetboard ingress

## [v7.3.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.3.0) (2023-01-30)
- Feat: Add puppetdb exporter (https://github.com/camptocamp/prometheus-puppetdb-exporter)
- Feat: starting to add unit test with Helm unittest
- Fix: issue with single master, `env` key was missing and raised an error
- Fix: unreported agent in puppetboard.
- Feat: bump postgresql chart version to `12.1.11`
- Feat: bump puppetboard version to `4.2.5`
- Feat: Improve pods security

## [v7.2.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.2.2) (2023-01-xx)
- Fix `storage.annotations` issue (https://github.com/puppetlabs/puppetserver-helm-chart/issues/148) apply code from PR https://github.com/puppetlabs/puppetserver-helm-chart/pull/149

## [v7.2.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.2.1) (2023-01-23)
- Fix: remove `timeout [-t SECS]` change from BusyBox v1.29.3 to BusyBox v1.33.1 `timeout SECS`

## [v7.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.2.0) (2023-01-18)
- Fix: puppetdb pvc deletion when preinstall job finnish before puppetdb pod start
- Feat: Allow crl to be updated as Kubernetes cron job instead of pod side car (share the crl between all deployment)
- Feat: Allow compilers to run as Deployment
- Feat: Review pvc creation between masters & compilers
- Feat: reorganize `singleCA` params
- Feat: use templating value for r10k image (to avoid duplication)
- Feat: allow running r10k a pod instead sidecar (share r10k code between all deployment)

## [v7.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.1.0) (2023-01-16)
- Fix `extraLabels` issue (https://github.com/puppetlabs/puppetserver-helm-chart/issues/135) apply code from PR https://github.com/puppetlabs/puppetserver-helm-chart/pull/137
- Fix: Rename all kubernetes resource with the release name as prefix
- Fix: move all configmap in /tmp to avoid Read Only error in puppetserver init container
- Fix: do not create r10k code credential secret if ssh or https existingSecret
- Fix: do not create r10k hiera credential secret if ssh or https existingSecret
- Fix: `r10k_hiera.yaml` templating, call the right variable
- Fix: crl script execution on puppetdb
- feat: bump R10k to `v3.15.2`.

## [v7.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v7.0.0) (2023-01-05)

- fix: autoscaling apiVersion, `autoscaling/v2` is available since 1.23
- fix: postgresql dependency (upgrade to the lastest available chart `12.1.6`)
- feat: add 2 init container on puppetdb deployment to start only when postgresql & puppet master is ready
- feat: allow custom config on puppetdb
- feat: bump Puppetserver to `v7.9.2`.
- feat: bump PuppetDB to `v7.10.0`.
- feat: bump Puppetboard to `v4.2.4`.
- fix: move configmap in /tmp to avoid Read Only error in puppetserver init container

## [v6.8.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.8.2) (2022-12-31)

- fix: set postgresql.fullnameOverride to match chart name, avoids error when release name is different

## [v6.8.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.8.1) (2022-12-07)

- fix: change order of scripts in master init or it will error out if compliers are enabled
- fix: add PUPPET_SSL_DIR env var and change check_for_masters.sh or init would wait indefinitely for ssl generation when running multi master
- fix: change from deprecated autoscaling/v2beta2 HorizontalPodAutoscaler to autoscaling/v2

## [v6.8.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.8.0) (2022-10-26)

- fix: Save crl to defined filename

## [v6.7.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.7.0) (2022-10-17)

- fix: have r10k-hiera extraSettings and extraRepos act like r10k-code and not print empty {} in r10k_hiera.yaml
- feat: add .Values.r10k.hiera.defaultRepoExtraConf and .Values.r10k.code.defaultRepoExtraConf to pass in yaml config for r10k_code.yaml and r10k_hiera.yaml configs

## [v6.6.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.6.0) (2022-10-04)

- feat: Allow to change load balancer type for puppet master if compilers are not used

## [v6.5.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.5.3) (2022-08-19)

- fix: Prevent errors when not specifying r10k.code.extraSettings or r10k.code.extraRepos

## [v6.5.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.5.2) (2022-08-18)

- fix: Prevent errors when not specifying extraInitArgs

## [v6.5.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.5.1) (2022-08-17)

- fix: add -t flag to timeout for r10k:3.14.0 and below

## [v6.5.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.5.0) (2022-07-29)

- feat: optional deployment of the puppetdb component (default true)
- feat: remove privileged from securityContext (I do not understand why it was used/needed??)
- feat: inject custom entrypoints which will be exuected during puppetserver startup
- feat: inject custom configmaps to configure puppetserver itself (configmaps mounted in /etc/puppetlabs/puppetserver/conf.d)
- feat: support extra r10k hiera & code repositories
- feat: add a restic backup Cronjob to backup our puppetserver master pv's
- fix: use r10k code & hiera extrasettings as map (global r10k configuration can be injected this way)
- fix: puppet service configured as ClusterIP only.
- fix: if compilers are deployed remove r10k container & code volumes from masters

## [v6.4.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.4.0) (2022-06-30)

- feat: add r10k cron job `splay`, `splayLimit` and `timeout` params

## [v6.3.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.3.0) (2022-06-29)

- feat: add `extraContainers` to both masters and compilers
- feat: add r10k cron job `successFile` params

## [v6.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.2.0) (2022-06-08)

- feat: update labels (match with Well-Known Labels) & add `extraLabels`
- feat: move dependencies charts in `Charts.yaml`
- feat: add `imagePullSecrets` param on all `Deployment`, `StatefulSet` and `Job`
- feat: restart puppet master & compiler when r10k configs are updated
- fix: DNS workaround with single CA mode & public CA
- fix: update documentation for `puppetdb.service`
- fix: puppetdb `update-crl` sidecar crash on some restart

## [v6.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.1.0) (2022-06-07)

- fix: postgresql dependency. bump from `10.4.*` to `10.16.*` (https://github.com/bitnami/charts/issues/10539)
- feat: drop Helm chart v2 support
- feat: improve puppetserver (master & compiler) startup with `startupProbe`
- feat: allow overriding harcoded variables

## [v6.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v6.0.0) (2022-06-01)

- feat: Single CA support (https://puppet.com/docs/puppet/7/config_ssl_external_ca.html)
- fix: define podsecuritypolicy.apiVersion
- fix copy issue with eyaml keys when use `existingSecret`
- fix puppetdb volume issue when use `customPersistentVolumeClaim`
- refactoring serviceAccount name

## [v5.20.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.20.0) (2022-05-31)

- Allow r10k cron jobs to be disabled
- Allow multi hieradata repos
- restart automatically pods if r10k or hiera configmap or secret change

## [v5.19.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.19.0) (2022-05-27)

- feat: deploy only necessary configuration regarding the solution (secret, keys defined in values.yaml, configmap )
- feat deploy only the most secure configuration (secret > keys defined in values.yaml > configMap)
- feat: generate a warning if configmap or keys are defined in values.yaml is used
- feat: generate an error if keys are defined in values.yaml and if .Values.eyaml.public_key or .Values.eyaml.private_key is missing

## [v5.18.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.18.0) (2022-05-20)

- feat: add pod security policies

## [v5.17.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.17.0) (2022-04-13)

- fix: delete parameter '--strip-components 1' of Puppetserver certificate (unzip)

## [v5.16.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.16.0) (2022-04-05)

- feat: make update strategy configurable

## [v5.15.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.15.0) (2022-04-20)

- feat: use k8s secrets instead of configmaps for eyaml secrets

## [v5.14.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.14.0) (2021-12-01)

- feat: bump Puppetserver to `v7.4.2`.
- feat: bump PuppetDB to `v7.7.1`.
- feat: bump R10K to `v3.13.0`.
- feat: bump Puppetboard to `v3.3.0`.

## [v5.13.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.13.0) (2021-11-29)

- feat(eyaml): allow more than one pub/priv keypair in existing eyaml key map

## [v5.12.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.12.0) (2021-09-21)

- feat: add support for Ingress `pathType` and `ingressClassName`.
- feat: bump Puppetserver to `v7.3.0`.
- feat: bump PuppetDB to `v7.5.2`.

## [v5.11.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.11.0) (2021-08-30)

- fix: set securityContext for puppetboard container

## [v5.10.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.10.0) (2021-08-30)

- feat: allow to expose puppetdb service outside of the kubernetes cluster

## [v5.9.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.9.0) (2021-08-12)

- feat: allow to override PUPPETDB_POSTGRES_HOSTNAME for puppetdb container

## [v5.8.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.8.0) (2021-07-22)

- feat: Add r10k.code.extraSettings and r10k.hiera.extraSettings
- feat: Add viaHttps options for r10k.code

## [v5.7.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.7.0) (2021-07-22)

- update: update to new api version (networking.k8s.io/v1) of ingress (v1.19+)

## [v5.6.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.6.2) (2021-07-21)

- fix: add pathType Prefix to puppetboard ingress

## [v5.6.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.6.1) (2021-07-20)

- fix: use correct puppetdb certs in puppetboard
- fix: persist CA, now located in /etc/puppetlabs/puppetserver/ca/

## [v5.6.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.6.0) (2021-05-01)

- update: Puppetserver to `v7.1.2`; PuppetDB to `v7.2.0`; r10k to `v3.8.0`; PostgreSQL chart to `v10.4.*`.
- fix: [Wrong parameter name in README to disable autosign](https://github.com/puppetlabs/puppetserver-helm-chart/issues/79).
- fix: bad naming for PuppetDB extra containers variable.
- fix: add missing placeholder for PuppetDB extra containers in `values.yaml`.
- fix: wrong url to Puppetserver chart v5.5.0 in `CHANGELOG`.

## [v5.5.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.5.0) (2021-04-30)

- fix: use puppetboard.port in puppetboard-ingress.yaml
- fix: use proper syntax for extra containers in puppetdb-deployment.yaml
- fix: force targetPorts in puppetdb-service.yaml
- enhancement: allow to specify puppetboard.service.targetPort

## [v5.4.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.4.0) (2021-04-26)

- Use official Puppetboard image, use port 9090, and allow extra PuppetDB containers.

## [v5.3.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.3.0) (2021-04-22)

- Add ability to ovewrite PuppetBoard variables in order to work properly with newer PuppetDB versions.

## [v5.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.2.0) (2021-03-29)

- Add ability to change PVC accessModes.

## [v5.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.1.0) (2021-02-07)

- Add ability to use custom PVCs.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v5.0.4...v5.1.0)

## [v5.0.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.0.4) (2020-11-02)

- Fix PuppetBoard showing "Internal server 500" when metric menu clicked.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v5.0.3...v5.0.4)

## [v5.0.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.0.3) (2020-11-01)

- Fix for r10k_code_cronjob.sh and r10k_hiera_cronjob.sh syntax error with `map[]`

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v5.0.2...v5.0.3)

## [v5.0.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.0.2) (2020-10-30)

- Fix for `DNS_ALT_NAMES` for non-compiler deployments.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v5.0.1...v5.0.2)

## [v5.0.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.0.1) (2020-09-19)

- Fix for resource names of Horizontal Pod Autoscalers.
- Several `README` updates.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v5.0.0...v5.0.1)

## [v5.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v5.0.0) (2020-09-12)

- Externalize the creation of PostgreSQL backend using the Bitnami's PostgreSQL Helm chart.
- Add high-availability and performance read replicas support for PostgreSQL.
- Add storage persistence for PostgreSQL.
- Allow only manual storage deletion for PostgreSQL.
- Tweak r10k cronjob schedules and Puppet Server components storage size.
- Add Hiera v5 example with explanations.
- Improve info comments and exemplary values in Values file.
- Bump PuppetDB to `v6.12.0`, and PostgreSQL to `v11.9.*`.
- Add `CODEOWNERS`.
- Numerous other small tweaks.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.4.0...v5.0.0)

## [v4.4.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.4.0) (2020-08-24)

- Allow for changing the default Puppet Server ports for Masters and Compilers.
- Switch to percentage `rollingUpdate` strategy for Puppet Masters.
- Set `updateStrategy` to `RollingUpdate` for Puppet Compilers.
- Bump `puppetserver` to `v6.12.1`, `puppetdb` to `v6.11.3`, `r10k` to `v3.5.2`, `puppetboard` to `v2.2.0`, `postgres` to `v9.6.19`.
- Code style fixes in "values.yaml".
- Improve `Testing the Deployed Chart Resources` in `README.md`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.3.0...v4.4.0)

## [v4.3.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.3.0) (2020-07-24)

- Liveness and readiness probes for Puppet Server.
- Adjust further resource naming.
- Style improvements in `README`.
- Small fixes in `values`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.2.1...v4.3.0)

## [v4.2.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.2.1) (2020-07-08)

- Fix naming for Puppet Server Masters' Ingress.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.2.0...v4.2.1)

## [v4.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.2.0) (2020-06-23)

- Add Helm v2 backward compatibility.
- Update README to reflect Helm v2 backward compatibility.
- Improve post-deployment NOTES to show recommended Puppet Server Masters K8s Service name.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.1.1...v4.2.0)

## [v4.1.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.1.1) (2020-06-22)

- Small adjustments in `README` for new chart app name and new default Puppetboard image owner.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.1.0...v4.1.1)

## [v4.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.1.0) (2020-06-22)

- Rework Puppetboard support.
- Add Puppetboard Service.
- Add optional Puppetboard Ingress.
- Change default chart app name to `puppetserver`.
- Bump Puppetboard to `v2.1.2`, r10k to `v3.5.1`, and PostgreSQL to `v9.6.18`.
- Other small improvements and fixes.
- Update `OWNERS`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v4.0.0...v4.1.0)

## [v4.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v4.0.0) (2020-06-08)

- Support for multiple Puppetserver Compilers (optionally) on different K8s nodes (incl. across different cloud zones).
- Improved support for multiple Puppetserver Masters.
- Switch to sidecar containers for r10k.
- Support for separate load-balancing between Puppetserver Master/s and Compiler/s.
- Simplified topology requirements (especially in the cloud).
- Improved resource naming.
- Ability to set K8s resource limits per component.
- Readiness probes for r10k.
- Improved built-in Go helpers.
- Lowered resource usage of the Puppetserver `initContainers`.
- More syntax consistent and easier to navigate templates code.
- Bump Puppetserver to `v6.10.0`, PuppetDB to `v6.10.1`, and PostgreSQL to `v9.6.17`.
- Various small improvements and fixes.
- Simpler documentation.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v3.0.2...v4.0.0)

## [v3.0.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v3.0.2) (2020-05-01)

- Add Puppet repo instruction to `README`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v3.0.1...v3.0.2)

## [v3.0.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v3.0.1) (2020-05-01)

- Documentation updates to reflect the new GitHub repo and contact details of the chart.
- Updated `install` and `test` instructions.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v3.0.0...v3.0.1)

## [v3.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v3.0.0) (2020-04-05)

- Helm v3 support.
- Improved documentation.
- Log msg fixes.
- Bump versions of Puppet Server (to v6.9.2) and PuppetDB (to v6.9.1).
- Other small fixes.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.8.2...v3.0.0)

## [v1.8.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.8.2) (2020-03-22)

- Better default auto-scaling and resource limits values for Puppetserver.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.8.1...v1.8.2)

## [v1.8.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.8.1) (2020-03-21)

- Fix auto-scaling of Puppetserver.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.8.0...v1.8.1)

## [v1.8.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.8.0) (2020-03-13)

- Better distinction between storage selectors.
- Bump default versions: Puppetserver to `6.9.0` and PuppetDB to `6.9.0`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.7.2...v1.8.0)

## [v1.7.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.7.2) (2020-02-11)

- Improve further `Chart.yaml`.
- Clean outdated comments in Values file.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.7.1...v1.7.2)

## [v1.7.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.7.1) (2020-02-01)

- Improve `Chart.yaml`.
- Bump default versions: Puppetserver to `6.8.0`, PostgreSQL to `9.6.16` and PuppetDB to `6.8.1`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.7.0...v1.7.1)

## [v1.7.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.7.0) (2020-01-27)

- Add support for multiple Puppet Compile Masters.
- Fix passing extra container environment variables.
- Indentation improvements.
- Bump default PuppetDB version to `6.8.0`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.6...v1.7.0)

## [v1.6.6](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.6) (2020-01-09)

- Fix outdated r10k exemplary variable in README.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.5...v1.6.6)

## [v1.6.5](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.5) (2020-01-05)

- Fixes for Helm packaging.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.4...v1.6.5)

## [v1.6.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.4) (2020-01-04)

- Corrections and additional info for use of Ingress resource.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.3...v1.6.4)

## [v1.6.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.3) (2020-01-03)

- Allow for using the chart as a chart package.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.2...v1.6.3)

## [v1.6.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.2) (2020-01-01)

- Puppetserver Service:

1. Allow for more general way of setting the network protocol.
2. Improve the way of setting the loadBalancerIP.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.1...v1.6.2)

## [v1.6.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.1) (2019-12-31)

- Add comments in Values file for Puppetserver Service.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.6.0...v1.6.1)

## [v1.6.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.6.0) (2019-12-26)

- Add optional affinity for "r10k" pod assignment.
- File permission fixes for "r10k" jobs' SSH keys.
- Security fixes for the "r10k" jobs.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.5.3...v1.6.0)

## [v1.5.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.5.3) (2019-12-09)

- Small README fixes.
- Add information about the chart in the main [README.md](https://github.com/puppetlabs/pupperware/blob/master/README.md) of Puppetlabs's Pupperware repo.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.5.2...v1.5.3)

## [v1.5.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.5.2) (2019-12-06)

- Fix PuppetDB usage of pre-generated Puppet SSL certs.
- Increase deadline time for Puppet pre-install job.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.5.1...v1.5.2)

## [v1.5.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.5.1) (2019-12-03)

- Small Indentation Fixes.
- Use Recommended Dir for PostreSQL's PGDATA.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.5.0...v1.5.1)

## [v1.5.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.5.0) (2019-12-02)

- Fixes and additions to setting SSH credentials from existing K8s secret.
- Create separate r10k jobs/schedules for Control Repo and Hiera Data.
- Place r10k cache on PVC.
- Deprecate HTTPS authentication.
- Indentation corrections.
- General code clean-up.
- Updates to README.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.4.0...v1.5.0)

## [v1.4.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.4.0) (2019-11-28)

- Add optional usage of pre-generated Puppet SSL certificates.
- Use default path for eYaml keys.
- Small Values file comment fixes.
- Code clean-up and lint fixes.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.3.1...v1.4.0)

## [v1.3.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.3.1) (2019-11-25)

- Small Values file fix.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.3.0...v1.3.1)

## [v1.3.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.3.0) (2019-11-25)

- [Firewall Related] Add support for separate r10k network protocols to gather the code of Puppet and Hiera repos.
- Increase default r10k sync runtime interval to every 5 minutes.
- Syntax improvements.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.2.2...v1.3.0)

## [v1.2.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.2.2) (2019-11-24)

- Fixes <https://github.com/puppetlabs/pupperware/issues/187> and <https://github.com/puppetlabs/pupperware/issues/188.>
- `r10k` now runs with the `puppet` username and group id - meaning all the files in `/etc/puppetlabs` are now owned by Puppet Server.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.2.1...v1.2.2)

## [v1.2.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.2.1) (2019-11-22)

- Fixes for "r10k" extra container args.
- Values file small fixes.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.2.0...v1.2.1)

## [v1.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.2.0) (2019-11-21)

- Add optional extra container environment variables.
- Add optional "r10k" extra container arguments.
- Bump PupptDB to v6.7.3.
- Small code indentation improvements.
- README updates.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.1.0...v1.2.0)

## [v1.1.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.1.0) (2019-11-19)

- Switch Pulling the Hiera Data Repo from Using "git_sync" to "r10k".

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.0.1...v1.1.0)

## [v1.0.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.0.1) (2019-11-11)

- Fix Permissions for Hiera, Puppet Server and eYaml Configs.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v1.0.0) (2019-11-08)

- Differentiate "nodeSelector" for Pods with Common Storage.
- Fix for PostgreSQL on AWS.
- Small Syntax and Indentation Fixes.
- Improve README.
- Improve Values Comments.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.3.5...v1.0.0)

## [v0.3.5](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.3.5) (2019-10-31)

- Add Optional `selector` for PVs/PVCs.
- Switch to Apache v2.0 License.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.3.4...v0.3.5)

## [v0.3.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.3.4) (2019-10-28)

- Add Ingress.
- Improve Tmpl Helpers.
- Improve `NOTES`.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.3.3...v0.3.4)

## [v0.3.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.3.3) (2019-10-27)

- Add Optional Static Data Volumes.
- Add Configurable PVC's Size.
- Add Optional PVC's Annotations.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.3.2...v0.3.3)

## [v0.3.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.3.2) (2019-10-26)

- Add optional extra Pod Annotations.
- Add optional Pod Priority Scheduling.
- Add LICENSE.
- Add CHANGELOG.
- Update README.
- Fixes.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.3.1...v0.3.2)

## [v0.3.1](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.3.1) (2019-10-24)

- Add optional "nodeSelector", "affinity" and "tolerations" for Pod Deployments.
- Improve Values Comments.
- Bump Component Versions.

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.2.4...v0.3.1)

## [v0.2.4](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.2.4) (2019-10-12)

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.2.3...v0.2.4)

## [v0.2.3](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.2.3) (2019-10-11)

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.2.2...v0.2.3)

## [v0.2.2](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.2.2) (2019-10-09)

[Full Changelog](https://github.com/puppetlabs/puppetserver-helm-chart/compare/v0.2.0...v0.2.2)

## [v0.2.0](https://github.com/puppetlabs/puppetserver-helm-chart/tree/v0.2.0) (2019-09-20)

\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
