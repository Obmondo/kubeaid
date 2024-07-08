# HELM Chart for Puppet Server

## Introduction

This chart bootstraps Puppet Server and its components on a Kubernetes cluster using the Helm package manager.

## Prerequisites

### Code Repos

* You must specify your Puppet Control Repo using `puppetserver.puppeturl` variable in the `values.yaml` file or include `--set puppetserver.puppeturl=<your_public_repo>` in the command line of `helm install`. You can specify your separate Hieradata Repo as well using the `hiera.hieradataurl` variable.

* You can also use private repos. Just remember to specify your credentials using `r10k.code.viaSsh.credentials.ssh.value` or `r10k.code.viaHttps.credentials.netrc.value`. You can set similar credentials for your Hieradata Repo.

### Load-Balancing Puppet Server

In case a Load Balancer (LB) must sit in front of Puppet Server - please keep in mind that having a Network LB (operating at OSI Layer 4) is preferable.

### NGINX Ingress Controller Configuration

The Ingress resource is disabled by default, but if it is enabled then ssl-passthrough must be used so that puppet agents will get the expected server certificate when connecting to the service.  This feature must be enabled on the Ingress resource itself, but also must be enabled via command line argument to the NGINX Ingress Controller.  More information on that can be found [here](<https://kubernetes.github.io/ingress-nginx/user-guide/cli-arguments/>).

> **NOTE**: Ingress URLs must be passed in the `Values.puppetserver.masters.fqdns.alternateServerNames`. Also - in the `Values.puppetserver.compilers.fqdns.alternateServerNames` (if Puppet Compilers and their Ingress resources are deployed).

## Migrating from Bare-Metal Puppet Infrastructure

### Auto-Signing Certificate Requests

In general, the easiest way to switch the Puppet Agents from using one Puppet master to another is by enabling the auto-signing of CSRs. By default, that has been pre-enabled in the Puppet Server Docker container. It can be disabled in the Values file by passing an extra environment variable: `AUTOSIGN=false` (in `.Values.puppetserver.masters.extraEnv`).

You will also need to remove the existing certificates in `/etc/puppetlabs/puppet/ssl` on each Puppet agent.

### Using Pre-Generated Puppet Master Certificates

If you prefer not to auto-sign or manually sign the Puppet Agents' CSRs - you can use the same Puppet master and PuppetDB certificates which you used in your bare-metal setup. Please archive into two separate files and place your certificates in the `init/puppet-certs/puppetserver` and `init/puppet-certs/puppetdb` directories and enable their usage in the Values file (`.Values.puppetserver.preGeneratedCertsJob.enabled`).

> **NOTE**: For more information please check - [README.md](init/README.md). For more general knowledge on the matter you can also read the article - <https://puppet.com/docs/puppet/5.5/ssl_regenerate_certificates.html.>

## Using Single CA

If you prefer, you can use a single externally issued CA - <https://puppet.com/docs/puppet/7/config_ssl_external_ca.html>.
Enable it with `.Values.singleCA.enable`, add the crl.pem url with `.Values.singleCA.crl.url`.

Generate puppet & puppetdb secret (must be name `puppet.pem` & `puppetdb.pem`):
```
kubectl create secret generic puppet-certificate --from-file=puppet.pem --from-file=puppet.key --from-file=ca.pem
kubectl create secret generic puppetdb-certificate --from-file=puppetdb.pem --from-file=puppetdb.key --from-file=ca.pem
```
finally set `.Values.singleCA.certificates.existingSecret.puppetserver` and `.Values.singleCA.certificates.existingSecret.puppetdb`.

Additionnaly, if you use a public certificate authority, you can't use private SAN name, so you have to override puppetdb name with `.Values.singleCA.puppetdb.overrideHostname` (with the full name ie: puppetdb.my.domain)

If you prefer, you can use crl update as cronjob instead of sidecar, it reduce resources utilization because only 1 pod is running.
:warning: it may not work on multi zone cluster. that why it's not enable by default

## Horizontal Scaling

To achieve better availability and higher throughput of Puppet Infrastructure, you'll need to scale out Puppet Masters and/or Puppet Compilers.

### Multiple Puppet Masters

To achieve better availability of Puppet Infrastructure, you can scale out Puppet Server Masters using `.Values.puppetserver.masters.multiMasters`. These Servers are known as masters, and are responsible for the creation and signing of your Puppet Agents' certificates. They are also responsible for receiving catalog requests from agents and synchronize the results with each other.

### Multiple Puppet Compilers

To achieve better throughput of Puppet Infrastructure, you can enable and scale out Puppet Server Compilers using `.Values.puppetserver.compilers`. These Servers are known as compile masters, and are simply additional load-balanced Puppet Servers that receive catalog requests from agents and synchronize the results with each other.

### Multiple PostgreSQL Read Replicas

For now it's not available anymore, since bitnami cleanned their old release. for multiple Postgresql we have to use postgresql-ha.
Read replica return an error on puppetdb:
`ERROR [p.p.c.services] Will retry database connection after temporary failure: java.sql.SQLTransientConnectionException: PDBMigrationsPool: default - Connection is not available, request timed out after 3002ms.`

## Deploy R10K as deployment
:warning: may not work in multi zone environment. that why it's not enable by default

You can configure r10k to run as deployment instead of sidecar to avoid r10k container multiplication (and avoid r10k run conflict)
to share r10k data between all componant (master or compiler), change the following values:
```
# values.yaml

# change this only if you use compilers
puppetserver:
    compilers:
        kind: Deployment

r10k:
  asSidecar: false
```

## Deploy Puppetserver deployment (master & compilers) as non root
:warning: for now only puppetserver can run as non root, it's not available for the puppetdb
It will run a pre-install job to configure all repository & permissions for masters & compilers

Benefits:
- running puppetserver with limited permissions
- improve puppetserver deployment (because certificate are not regenerated each time)

You can enable it using:
```
global.runAsNonRoot: true
```


## Chart Components

* Creates three deployments: Puppet Server Master/s, and PuppetDB.
* Creates three statefulsets (optional): Puppet Server Compiler/s, PostgreSQL Master, and PostgreSQL Read Replicas.
* Creates seven services that expose: Puppet Server Masters, Puppet Server Compilers (optional), PuppetDB, PostgreSQL, and Puppetboard (optional).
* Creates secrets to hold credentials for PuppetDB, PosgreSQL, and r10k.

## Installing the Chart

### Add Puppet Server Helm Repository

Before installing Puppet Server Helm chart, you need to add the [Puppet Server Helm repository](https://puppetlabs.github.io/puppetserver-helm-chart) to your Helm client as below.

```bash
helm repo add puppet https://puppetlabs.github.io/puppetserver-helm-chart
```

### Install the Chart

To install the chart with the release name `puppetserver`.

```bash
helm install --namespace puppetserver --name puppetserver puppet/puppetserver --set puppetserver.puppeturl='https://github.com/$SOMEUSER/control-repo.git'
```

> Note - If you do not specify a name, helm will select a name for you.

### Installed Components

You can use `kubectl get` to view all of the installed components.

```console
$ kubectl get --namespace puppetserver all
NAME                                                   READY   STATUS    RESTARTS   AGE
pod/puppetserver-postgresql-master-0                   1/1     Running   0          9m25s
pod/puppetserver-postgresql-slave-0                    1/1     Running   0          9m25s
pod/puppetserver-puppetdb-fc4978b6d-z9bsx              2/2     Running   0          9m25s
pod/puppetserver-puppetserver-compiler-0               2/2     Running   0          9m25s
pod/puppetserver-puppetserver-master-7b59cb946-9bwv6   2/2     Running   0          9m25s

NAME                                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                    AGE
service/agents-to-puppet                   ClusterIP   10.96.236.202   <none>        8140/TCP                   9m25s
service/puppet                             ClusterIP   10.96.51.23     <none>        8140/TCP                   9m25s
service/puppet-compilers                   ClusterIP   10.96.185.43    <none>        8140/TCP                   9m25s
service/puppet-compilers-headless          ClusterIP   None            <none>        443/TCP                    9m25s
service/puppetdb                           ClusterIP   10.96.160.91    <none>        8080/TCP,8081/TCP,80/TCP   9m25s
service/puppetserver-postgresql            ClusterIP   10.96.48.166    <none>        5432/TCP                   9m25s
service/puppetserver-postgresql-headless   ClusterIP   None            <none>        5432/TCP                   9m25s
service/puppetserver-postgresql-read       ClusterIP   10.96.219.155   <none>        5432/TCP                   9m25s

NAME                                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/puppetserver-puppetdb              1/1     1            1           9m25s
deployment.apps/puppetserver-puppetserver-master   1/1     1            1           9m25s

NAME                                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/puppetserver-puppetdb-fc4978b6d              1         1         1       9m25s
replicaset.apps/puppetserver-puppetserver-master-7b59cb946   1         1         1       9m25s

NAME                                                  READY   AGE
statefulset.apps/puppetserver-postgresql-master       1/1     9m25s
statefulset.apps/puppetserver-postgresql-slave        1/1     9m25s
statefulset.apps/puppetserver-puppetserver-compiler   1/1     9m25s

NAME                                                                    REFERENCE                                         TARGETS                        MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/puppetserver-compilers-autoscaler   StatefulSet/puppetserver-puppetserver-compilers   33%/75%, 47%/75%               1         3         0          9m25s
```

## Upgrading

### from 7.x to 8.0

`customPersistentVolumeClaim` was removed instead check `puppetdb.persistence.existingClaim` or `puppetserver.persistence.*.existingClaim` for similar functionnality.

Added support for setting the size and Storage Class of individual Persistent Volume Claims fullfilling most uses of `customPersistentVolumeClaim` check `puppetdb.persistence.size` `puppetdb.persistence.storageClass`, `puppetserver.persistence.*.storageClass` and `puppetserver.persistence.*.size` for more information.

## Configuration

The following table lists the configurable parameters of the Puppetserver chart and their default values.

| Parameter | Description | Default|
| --------- | ----------- | -------|
| `global.runAsNonRoot`| run puppetserver as non root |`false`|
| `global.curl.image`| curl image |`curlimages/curl`|
| `global.curl.tag`| curl image tag |`7.87.0`|
| `global.curl.imagePullPolicy`| curl image pull policy |`IfNotPresent`|
| `global.imagePullSecrets` | Global Docker registry secret names as an array | [] |
| `global.pgchecker.image`| pgchecker image |`docker.io/busybox`|
| `global.pgchecker.tag`| pgchecker image tag |`1.36`|
| `global.pgchecker.imagePullPolicy`| pgchecker image pull policy |`IfNotPresent`|
| `global.puppetdbexporter.image`| puppetdb exporter image |`camptocamp/prometheus-puppetdb-exporter`|
| `global.puppetdbexporter.tag`| puppetdb exporter image tag |`1.1.0`|
| `global.puppetdbexporter.imagePullPolicy`| puppetdb exporter image pull policy |`IfNotPresent`|
| `global.postgresql.auth.username`| puppetdb and postgresql username |`puppetdb`|
| `global.postgresql.auth.password`| puppetdb and postgresql password |`unbreakablePassword`|
| `global.postgresql.auth.existingSecret`| existing k8s secret that holds puppetdb and postgresql username and password |``|
| `global.postgresql.*`| please refer to https://github.com/bitnami/charts/tree/main/bitnami/postgresql#global-parameters |``|
| `global.r10k.image` | r10k image | `puppet/r10k`|
| `global.r10k.tag` | r10k img tag | `3.15.2`|
| `global.r10k.imagePullPolicy`| r10k image pull policy |`IfNotPresent`|
| `global.extraEnv.*`| add extra environment variables to all containers |``|
| `global.extraEnvSecret`| add extra environment variables to all containers from pre-existing secret |``|
| `puppetserver.name` | puppetserver component label | `puppetserver`|
| `puppetserver.image` | puppetserver image | `voxpupuli/container-puppetserver`|
| `puppetserver.tag` | puppetserver img tag | `7.17.0-v1.5.0`|
| `puppetserver.pullPolicy` | puppetserver img pull policy | `IfNotPresent`|
| `puppetserver.persistence.data.enabled`| Persists /opt/puppetlabs/server/data/puppetserver/ in a PVC |`true`|
| `puppetserver.persistence.data.existingClaim`| If non-empty, use a pre-defined PVC for puppet data |``|
| `puppetserver.persistence.data.accessModes`| If existingClaim is empty, the accessModes of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.data.storageClass`| If existingClaim is empty, the storageClass of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.data.annotations`| If existingClaim is empty, the annotations of the PVC created by the chart | the value of `storage.annotations` |
| `puppetserver.persistence.data.size`| If existingClaim is empty, the size of the PVC created by the chart | the value of `storage.size` |
| `puppetserver.persistence.puppet.existingClaim`| If non-empty, use a pre-defined PVC for the puppet directory |``|
| `puppetserver.persistence.puppet.accessModes`| If existingClaim is empty, the accessModes of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.puppet.storageClass`| If existingClaim is empty, the storageClass of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.puppet.annotations`| If existingClaim is empty, the annotations of the PVC created by the chart | the value of `storage.annotations` |
| `puppetserver.persistence.puppet.size`| If existingClaim is empty, the size of the PVC created by the chart | the value of `storage.size` |
| `puppetserver.persistence.code.existingClaim`| If non-empty, use a pre-defined PVC for the puppet code |``|
| `puppetserver.persistence.code.accessModes`| If existingClaim is empty, the accessModes of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.code.storageClass`| If existingClaim is empty, the storageClass of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.code.annotations`| If existingClaim is empty, the annotations of the PVC created by the chart | the value of `storage.annotations` |
| `puppetserver.persistence.code.size`| If existingClaim is empty, the size of the PVC created by the chart | the value of `storage.size` |
| `puppetserver.persistence.ca.existingClaim`| If non-empty, use a pre-defined PVC for the puppet CA certificates |``|
| `puppetserver.persistence.ca.accessModes`| If existingClaim is empty, the accessModes of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.ca.storageClass`| If existingClaim is empty, the storageClass of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.ca.annotations`| If existingClaim is empty, the annotations of the PVC created by the chart | the value of `storage.annotations` |
| `puppetserver.persistence.ca.size`| If existingClaim is empty, the size of the PVC created by the chart | the value of `storage.size` |
| `puppetserver.persistence.confd.enabled`| Persists /etc/puppetlabs/puppetserver/conf.d/ in a PVC |`true`|
| `puppetserver.persistence.confd.existingClaim`| If non-empty, use a pre-defined PVC for the puppet conf.d directory |``|
| `puppetserver.persistence.confd.accessModes`| If existingClaim is empty, the accessModes of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.confd.storageClass`| If existingClaim is empty, the storageClass of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.confd.annotations`| If existingClaim is empty, the annotations of the PVC created by the chart | the value of `storage.annotations` |
| `puppetserver.persistence.confd.size`| If existingClaim is empty, the size of the PVC created by the chart | the value of `storage.size` |
| `puppetserver.persistence.server.existingClaim`| If non-empty, use a pre-defined PVC for the puppetserver |``|
| `puppetserver.persistence.server.accessModes`| If existingClaim is empty, the accessModes of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.server.storageClass`| If existingClaim is empty, the storageClass of the PVC created by the chart | the value of `storage.accessModes` |
| `puppetserver.persistence.server.annotations`| If existingClaim is empty, the annotations of the PVC created by the chart | the value of `storage.annotations` |
| `puppetserver.persistence.server.size`| If existingClaim is empty, the size of the PVC created by the chart | the value of `storage.size` |
| `puppetserver.masters.resources` | puppetserver masters resource limits | ``|
| `puppetserver.masters.podAntiAffinity` | puppetserver masters pod affinity constraints |`false`|
| `puppetserver.masters.podDisruptionBudget.enabled` | enable PodDisruptionBudget on puppetserver masters | `false`|
| `puppetserver.masters.podDisruptionBudget.minAvailable` | represents the number of Pods that must be available (integer or percentage) on puppetserver masters | `1`|
| `puppetserver.masters.podDisruptionBudget.maxUnavailable` | represents the number of Pods that can be unavailable (integer or percentage) on puppetserver masters | ``|
| `puppetserver.masters.networkPolicy.enabled` | enable `networkPolicy` on  puppetserver masters | `false`|
| `puppetserver.masters.networkPolicy.policyTypes` | default networkpolicy type n puppetserver masters | `[ Egress, Ingress ]`|
| `puppetserver.masters.networkPolicy.additionnalIngressRules` | puppetserver masters resource limits | `allow 8140 from everywhere` |
| `puppetserver.masters.extraContainers`| Extra containers to inject into the master pod |``|
| `puppetserver.masters.extraEnv` | puppetserver masters additional container env vars |``|
| `puppetserver.masters.extraEnvSecret` | puppetserver masters additional container env vars from pre-existing secret |``|
| `puppetserver.masters.extraLabels` | puppetserver masters additional labels |``|
| `puppetserver.masters.updateStrategy` | puppetserver masters update strategy |`RollingUpdate`|
| `puppetserver.masters.readinessProbeInitialDelay` | the initial delay for the puppetserver masters readiness probe | `180`|
| `puppetserver.masters.readinessProbePeriodSeconds` | how often (in seconds) to perform the puppetserver masters readiness probe | `60`|
| `puppetserver.masters.readinessProbeTimeout` | the timeout for the puppetserver masters readiness probe | `20`|
| `puppetserver.masters.readinessProbeFailureThreshold` | the failure threshold for the puppetserver masters readiness probe | `3`|
| `puppetserver.masters.readinessProbeSuccessThreshold` | the success threshold for the puppetserver masters readiness probe | `1`|
| `puppetserver.masters.readinessProbeScheme` | the readiness probe scheme to be used | `HTTPS`|
| `puppetserver.masters.livenessProbeInitialDelay` | the initial delay for the puppetserver masters liveness probe | `420`|
| `puppetserver.masters.livenessProbePeriodSeconds` | how often (in seconds) to perform the puppetserver masters liveness probe | `30`|
| `puppetserver.masters.livenessProbeTimeout` | the timeout for the puppetserver masters liveness probe  | `10`|
| `puppetserver.masters.livenessProbeFailureThreshold` | the failure threshold for the puppetserver masters liveness probe | `3`|
| `puppetserver.masters.livenessProbeSuccessThreshold` | the success threshold for the puppetserver masters liveness probe | `1`|
| `puppetserver.masters.startupProbePeriodSeconds` | the timeout for the puppetserver masters startup probe  | `60`|
| `puppetserver.masters.fqdns.alternateServerNames` | puppetserver masters alternate fqdns |``|
| `puppetserver.masters.service.type` | puppetserver masters svc type | `ClusterIP`|
| `puppetserver.masters.service.ports` | puppetserver masters svc exposed ports | `puppetserver`|
| `puppetserver.masters.service.annotations`| puppetserver masters svc annotations |``|
| `puppetserver.masters.service.labels`| puppetserver additional masters svc labels |``|
| `puppetserver.masters.service.loadBalancerIP`| puppetserver masters svc loadbalancer ip |``|
| `puppetserver.masters.ingress.enabled`| puppetserver masters ingress creation enabled |`false`|
| `puppetserver.masters.ingress.annotations`| puppetserver masters ingress annotations |``|
| `puppetserver.masters.ingress.extraLabels`| puppetserver masters ingress extraLabels |``|
| `puppetserver.masters.ingress.hosts`| puppetserver masters ingress hostnames |``|
| `puppetserver.masters.ingress.tls`| puppetserver masters ingress tls configuration |``|
| `puppetserver.masters.multiMasters.enabled` | If true, creates multiple Puppetserver masters | `false`|
| `puppetserver.masters.multiMasters.manualScaling.masters` | If multiple masters are enabled, this field sets masters count | `1`|
| `puppetserver.masters.multiMasters.autoScaling.enabled` | If true, creates masters Horizontal Pod Autoscaler | `false`|
| `puppetserver.masters.multiMasters.autoScaling.minMasters` | If masters autoscaling enabled, this field sets minimum masters count | `1`|
| `puppetserver.masters.multiMasters.autoScaling.maxMasters` | If masters autoscaling enabled, this field sets maximum masters count | `3`|
| `puppetserver.masters.multiMasters.autoScaling.cpuUtilizationPercentage` | Target masters CPU utilization percentage to scale | `75`|
| `puppetserver.masters.multiMasters.autoScaling.memoryUtilizationPercentage` | Target masters memory utilization percentage to scale | `75`|
| `puppetserver.masters.backup.enabled` | If true, enable master backup with a kubernetes CronJob and restic | `false`|
| `puppetserver.masters.backup.resources` | puppetserver restic backup CronJob resource limits | ``|
| `puppetserver.masters.backup.failedJobsHistoryLimit` | puppetserver restic backup CronJob failedJobsHistoryLimit | `5`|
| `puppetserver.masters.backup.successfulJobsHistoryLimit` | puppetserver restic backup CronJob successfulJobsHistoryLimit | `2`|
| `puppetserver.masters.backup.schedule` | puppetserver restic backup CronJob schedule | `@every 12h`|
| `puppetserver.masters.backup.image` | puppetserver restic backup CronJob image | `restic/restic`|
| `puppetserver.masters.backup.tag` | puppetserver restic backup CronJob image tag | `0.13.1`|
| `puppetserver.masters.backup.pullPolicy` | puppetserver restic backup CronJob image pullPolicy | `IfNotPresent`|
| `puppetserver.masters.backup.caConfigMap` | puppetserver restic backup CronJob configmap for custom ca-certificates.crt | ``|
| `puppetserver.masters.backup.restic.keep_last` | puppetserver restic backup CronJob keep last n days | `90`|
| `puppetserver.masters.backup.restic.repository` | puppetserver restic backup CronJob s3 compatible repository | ``|
| `puppetserver.masters.backup.restic.access_key_id` | puppetserver restic backup CronJob s3 access_key_id | ``|
| `puppetserver.masters.backup.restic.secret_access_key` | puppetserver restic backup CronJob s3 secret_access_key | ``|
| `puppetserver.masters.backup.restic.password` | puppetserver restic backup CronJob encryption password  | ``|
| `puppetserver.compilers.enabled` | If true, creates Puppetserver compilers | `false`|
| `puppetserver.compilers.resources` | puppetserver compilers resource limits |``|
| `puppetserver.compilers.podAntiAffinity` | puppetserver compilers pod affinity constraints |`false`|
| `puppetserver.compilers.podDisruptionBudget.enabled` | enable PodDisruptionBudget on puppetserver compilers | `false`|
| `puppetserver.compilers.podDisruptionBudget.minAvailable` | represents the number of Pods that must be available (integer or percentage) on puppetserver compilers | `1`|
| `puppetserver.compilers.podDisruptionBudget.maxUnavailable` | represents the number of Pods that can be unavailable (integer or percentage) on puppetserver compilers | ``|
| `puppetserver.compilers.networkPolicy.enabled` | enable `networkPolicy` on  puppetserver compilers | `false`|
| `puppetserver.compilers.networkPolicy.policyTypes` | default networkpolicy type on puppetserver compilers  | `[ Egress, Ingress ]`|
| `puppetserver.compilers.networkPolicy.additionnalIngressRules` | puppetserver compilers resource limits | `allow 8140 from everywhere` |
| `puppetserver.compilers.annotations`| puppetserver compilers statefulset annotations |``|
| `puppetserver.compilers.extraContainers`| Extra containers to inject into the compiler pod |``|
| `puppetserver.compilers.extraEnv` | puppetserver compilers additional container env vars |``|
| `puppetserver.compilers.extraEnvSecret` | puppetserver compilers additional container env vars from pre-existing secret |``|
| `puppetserver.compilers.extraLabels` | puppetserver compilers additional labels |``|
| `puppetserver.compilers.updateStrategy` | puppetserver compilers update strategy |`RollingUpdate`|
| `puppetserver.compilers.readinessProbeInitialDelay` | the initial delay for the puppetserver masters readiness probe | `180`|
| `puppetserver.compilers.readinessProbePeriodSeconds` | how often (in seconds) to perform the puppetserver masters readiness probe | `60`|
| `puppetserver.compilers.readinessProbeTimeout` | the timeout for the puppetserver masters readiness probe | `20`|
| `puppetserver.compilers.readinessProbeFailureThreshold` | the failure threshold for the puppetserver masters readiness probe | `3`|
| `puppetserver.compilers.readinessProbeSuccessThreshold` | the success threshold for the puppetserver masters readiness probe | `1`|
| `puppetserver.compilers.readinessScheme` | the readiness probe scheme to be used | `HTTPS`|
| `puppetserver.compilers.livenessProbeInitialDelay` | the initial delay for the puppetserver masters liveness probe | `420`|
| `puppetserver.compilers.livenessProbePeriodSeconds` | how often (in seconds) to perform the puppetserver masters liveness probe | `30`|
| `puppetserver.compilers.livenessProbeTimeout` | the timeout for the puppetserver masters liveness probe  | `10`|
| `puppetserver.compilers.livenessProbeFailureThreshold` | the failure threshold for the puppetserver masters liveness probe | `3`|
| `puppetserver.compilers.livenessProbeSuccessThreshold` | the success threshold for the puppetserver masters liveness probe | `1`|
| `puppetserver.compilers.manualScaling.compilers` | If multiple compilers are enabled, this field sets compiler count | `1`|
| `puppetserver.compilers.autoScaling.enabled` | If true, creates compilers Horizontal Pod Autoscaler | `false`|
| `puppetserver.compilers.autoScaling.minCompilers` | If autoscaling enabled, this field sets minimum compiler count | `1`|
| `puppetserver.compilers.autoScaling.maxCompilers` | If compilers autoscaling enabled, this field sets maximum compiler count | `3`|
| `puppetserver.compilers.autoScaling.cpuUtilizationPercentage` | Target compilers CPU utilization percentage to scale | `75`|
| `puppetserver.compilers.autoScaling.memoryUtilizationPercentage` | Target compilers memory utilization percentage to scale | `75`|
| `puppetserver.compilers.podManagementPolicy` | puppetserver compilers statefulset pod management policy | `OrderedReady`|
| `puppetserver.compilers.fqdns.alternateServerNames` | puppetserver compilers alternate fqdns |``|
| `puppetserver.compilers.service.type` | puppetserver compilers svc type | `ClusterIP`|
| `puppetserver.compilers.service.ports` | puppetserver compilers svc exposed ports | `puppetserver`|
| `puppetserver.compilers.service.annotations`| puppetserver compilers svc annotations |``|
| `puppetserver.compilers.service.labels`| puppetserver compilers additional svc labels |``|
| `puppetserver.compilers.service.loadBalancerIP`| puppetserver compilers svc loadbalancer ip |``|
| `puppetserver.compilers.service.headless.ports`| puppetserver compilers headless svc loadbalancer ip |`https`|
| `puppetserver.compilers.service.headless.annotations`| puppetserver compilers headless svc annotations |``|
| `puppetserver.compilers.service.headless.labels`| puppetserver compilers additional headless svc labels |``|
| `puppetserver.compilers.ingress.enabled`| puppetserver compilers ingress creation enabled |`false`|
| `puppetserver.compilers.ingress.annotations`| puppetserver compilers ingress annotations |``|
| `puppetserver.compilers.ingress.extraLabels`| puppetserver compilers ingress extraLabels |``|
| `puppetserver.compilers.ingress.hosts`| puppetserver compilers ingress hostnames |``|
| `puppetserver.compilers.ingress.tls`| puppetserver compilers ingress tls configuration |``|
| `puppetserver.preGeneratedCertsJob.enabled` | puppetserver pre-generated certs |`false`|
| `puppetserver.preGeneratedCertsJob.importPuppetdb` | import puppetdb pre-generated certs |`true`|
| `puppetserver.preGeneratedCertsJob.jobDeadline` | puppetserver pre-generated certs job deadline in seconds |`60`|
| `puppetserver.puppeturl`| puppetserver control repo url |``|
| `puppetserver.serviceAccount.enabled`| Enable service account (Note: Service Account will only be automatically created if `puppetserver.serviceAccount.create` is not set.  |`false`|
| `puppetserver.serviceAccount.create`| puppetserver additional masters svc labels |`false`|
| `puppetserver.rbac.create`| Enable PodSecurityPolicy's RBAC rules |`false`|
| `puppetserver.psp.create`| Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later |`false`|
| `puppetserver.customconfigs.enabled`| puppetserver additional config map enabled |`false`|
| `puppetserver.customconfigs.configmaps`| puppetserver additional config maps which will be mounted in /etc/puppetlab/puppetserver/conf.d/ |``|
| `puppetserver.customentrypoints.enabled`| puppetserver additional entrypoint scripts. will be executed before puppetserver launch |`false`|
| `puppetserver.customentrypoints.configmaps`| puppetserver additional configmaps |``|
| `puppetserver.extraSecrets`| puppetserver additional secret which will be mounted in pod |``|
| `puppetserver.extraInitArgs`| puppetserver additional initArgs |``|
| `r10k.name` | r10k component label | `r10k`|
| `r10k.image` | r10k img | `puppet/r10k`|
| `r10k.tag` | r10k img tag | `3.15.2`|
| `r10k.pullPolicy` | r10k img pull policy | `IfNotPresent`|
| `r10k.code.resources` | r10k control repo resource limits |``|
| `r10k.code.command` | r10k entrypoint command | [`/bin/sh`,`-c`]|
| `r10k.code.args` | r10k entrypoint command argument |[`/etc/puppetlabs/puppet/r10k_code_entrypoint.sh;`]|
| `r10k.code.readinessProbe` | r10k entrypoint |[`/bin/sh`, `-ec`, `test -f {{ .Values.r10k.code.cronJob.successFile }}`] |
| `r10k.code.cronJob.enabled` | enable or disable r10k control repo cron job schedule policy | `true`|
| `r10k.code.cronJob.schedule` | r10k control repo cron job schedule policy | `*/15 * * * *`|
| `r10k.code.cronJob.splay` | apply random sleep before running r10k control repo cron job | `true`|
| `r10k.code.cronJob.splayLimit` | maximum splay in seconds applied before running r10k control repo cron job | `60`|
| `r10k.code.cronJob.timeout` | timeout in seconds to apply when running r10k control repo cron job takes too long | ``|
| `r10k.code.cronJob.successFile` | path to file reflecting success of r10k control repo cron job | `~/.r10k_code_cronjob.success`|
| `r10k.code.defaultRepoExtraConf` | yaml to be added to the default repo in r10k_code.yaml |``|
| `r10k.code.extraArgs` | r10k control repo additional container env args |``|
| `r10k.code.extraEnv` | r10k control repo additional container env vars |``|
| `r10k.code.extraEnvSecret` | r10k control repo additional container env vars from pre-existing secret |``|
| `r10k.code.viaSsh.credentials.ssh.value`| r10k control repo ssh key file |``|
| `r10k.code.viaSsh.credentials.known_hosts.value`| r10k control repo ssh known hosts file |``|
| `r10k.code.viaSsh.credentials.existingSecret`| r10k control repo ssh secret that holds ssh key and known hosts files |``|
| `r10k.code.viaHttps.credentials.netrc.value`| r10k control repo https .netrc file |``|
| `r10k.code.viaHttps.credentials.existingSecret`| r10k control repo https secret that holds .netrc file contents in `netrc` key |``|
| `r10k.code.viaHttps.customCa.cert.value`| r10k control repo https custom CA file in PEM format |``|
| `r10k.code.viaHttps.customCa.existingSecret`| r10k control repo https secret that holds custom CA file in PEM format in `cert` key |``|
| `r10k.hiera.resources` | r10k hiera data resource limits |``|
| `r10k.hiera.cronJob.enabled` | enable or disable r10k hiera data cron job schedule policy | `true`|
| `r10k.hiera.cronJob.schedule` | r10k hiera data cron job schedule policy | `*/2 * * * *`|
| `r10k.hiera.cronJob.splay` | apply random sleep before running r10k hiera data cron job | `true`|
| `r10k.hiera.cronJob.splayLimit` | maximum splay in seconds applied before running r10k hiera data cron job | `60`|
| `r10k.hiera.cronJob.timeout` | timeout in seconds to apply when running r10k hiera data cron job takes too long | ``|
| `r10k.hiera.cronJob.successFile` | path to file reflecting success of r10k hiera data cron job | `~/.r10k_hiera_cronjob.success`|
| `r10k.hiera.defaultRepoExtraConf` | yaml to be added to the default repo in r10k_hiera.yaml |``|
| `r10k.hiera.extraArgs` | r10k hiera data additional container env args |``|
| `r10k.hiera.extraEnv` | r10k hiera data additional container env vars |``|
| `r10k.hiera.extraEnvSecret` | r10k hiera data additional container env vars from pre-existing secret |``|
| `r10k.hiera.viaSsh.credentials.ssh.value`| r10k hiera data ssh key file |``|
| `r10k.hiera.viaSsh.credentials.known_hosts.value`| r10k hiera data ssh known hosts file |``|
| `r10k.hiera.viaSsh.credentials.existingSecret`| r10k hiera data ssh secret that holds ssh key and known hosts files |``|
| `r10k.hiera.viaHttps.credentials.netrc.value`| r10k hiera data https .netrc file |``|
| `r10k.hiera.viaHttps.credentials.existingSecret`| r10k hiera data https secret that holds .netrc file contents in `netrc` key |``|
| `postgresql.*`| please refer to <https://github.com/bitnami/charts/tree/main/bitnami/postgresql#parameters> |``|
| `postgresql.primary.initdb.scriptsConfigMap` | postgres initdb scripts run at first boot |`postgresql-custom-extensions`|
| `postgresql.primary.persistence.enabled` | postgres database persistence |`true`|
| `postgresql.primary.persistence.existingClaim` | postgres manually managed pvc |``|
| `postgresql.primary.persistence.size` | postgres persistence pvc size |`10Gi`|
| `postgresql.primary.persistence.annotations` | postgres annotations for the PVC |`helm.sh/resource-policy: keep`|
| `postgresql.networkPolicy.enabled` | enable `networkPolicy` on  postgresql | `true`|
| `puppetdb.enabled` | puppetdb component enabled |`true`|
| `puppetdb.name` | puppetdb component label | `puppetdb`|
| `puppetdb.image` | puppetdb img | `voxpupuli/container-puppetdb`|
| `puppetdb.tag` | puppetdb img tag | `7.18.0-v1.5.0`|
| `puppetdb.pullPolicy` | puppetdb img pull policy | `IfNotPresent`|
| `puppetdb.resources` | puppetdb resource limits |``|
| `puppetdb.extraEnv` | puppetdb additional container env vars |``|
| `puppetdb.extraEnvSecret` | puppetdb additional container env vars from pre-existing secret |``|
| `puppetdb.extraLabels` | puppetdb additional labels |``|
| `puppetdb.fqdns.alternateServerNames` | puppetdb alternate fqdns |``|
| `puppetdb.service.type` | define `spec.type` for the puppetdb service |`ClusterIP`|
| `puppetdb.service.annotations` | puppetdb service annotations |``|
| `puppetdb.service.labels` | puppetdb service labels |``|
| `puppetdb.service.loadBalancerIP` | define a fixed IP for the loadBalancerIP service |``|
| `puppetdb.service.clusterIP` | define a fixed IP for the ClusterIP service |``|
| `puppetdb.updateStrategy` | puppetdb update strategy |`Recreate`|
| `puppetdb.metrics.enabled` | puppetdb metrics enable/disable flag |`false`|
| `puppetdb.customPersistentVolumeClaim.storage.enable`| If true, use custom PVC for storage |``|
| `puppetdb.customPersistentVolumeClaim.storage.config`| Configuration for custom PVC for storage |``|
| `puppetdb.securityContext` | default puppetdb security context | ``|
| `puppetdb.networkPolicy.enabled` | enable `networkPolicy` on  puppetdb | `false`|
| `puppetdb.networkPolicy.policyTypes` | default networkpolicy type on puppetdb  | `[ Egress, Ingress ]`|
| `puppetdb.networkPolicy.additionnalIngressRules` | puppetdb resource limits | `allow 9090 from everywhere` |
| `puppetdb.extraContainers`| Extra containers to inject into the puppetdb pod |``|
| `puppetdb.extraInitContainers`| Extra initContainers to inject into the puppetdb pod |``|
| `puppetdb.serviceAccount.enabled`| Enable service account (Note: Service Account will only be automatically created if `puppetdb.serviceAccount.create` is not set.  |`false`|
| `puppetdb.customconfigs.enabled`| puppetdb additional config map enabled |`false`|
| `puppetdb.serviceAccount.create`| puppetdb additional masters svc labels |`false`|
| `puppetdb.rbac.create`| Enable PodSecurityPolicy's RBAC rules |`false`|
| `puppetdb.psp.create`| Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later |`false`|
| `puppetboard.enabled` | puppetboard availability | `false`|
| `puppetboard.name` | puppetboard component label | `puppetboard`|
| `puppetboard.image` | puppetboard img | `xtigyro/puppetboard`|
| `puppetboard.tag` | puppetboard img tag | `2.1.2`|
| `puppetboard.port` | puppetboard container port | `9090`|
| `puppetboard.pullPolicy` | puppetboard img pull policy | `IfNotPresent`|
| `puppetboard.resources` | puppetboard resource limits |``|
| `puppetboard.extraEnv` | puppetboard additional container env vars |``|
| `puppetboard.extraEnvSecret` | puppetboard additional container env vars from pre-existing secret |``|
| `puppetboard.service.targetPort` | target port for the puppetboard service port |`puppetboard`|
| `puppetboard.ingress.enabled`| puppetboard ingress creation enabled |`false`|
| `puppetboard.ingress.annotations`| puppetboard ingress annotations |``|
| `puppetboard.ingress.extraLabels`| puppetboard ingress extraLabels |``|
| `puppetboard.ingress.hosts`| puppetboard ingress hostnames |``|
| `puppetboard.ingress.tls`| puppetboard ingress tls configuration |``|
| `hiera.name` | hiera component label | `hiera`|
| `hiera.hieradataurl`| hieradata repo url |``|
| `hiera.config`| hieradata yaml config |``|
| `hiera.eyaml.private_key`| hiera eyaml private key |``|
| `hiera.eyaml.public_key`| hiera eyaml public key |``|
| `nameOverride`| puppetserver components name for `component:` labels |``|
| `nodeSelector`| Node labels for pod assignment |``|
| `affinity`| Affinity for pod assignment |``|
| `tolerations`| Tolerations for pod assignment |``|
| `priorityClass`| Leverage a priorityClass to ensure your pods survive resource shortages |``|
| `podAnnotations`| Extra Pod annotations |``|
| `storage.accessModes`| Storage Access Modes (expects array) |`["ReadWriteOnce"]`|
| `storage.storageClass`| Storage Class |``|
| `storage.annotations`| Storage annotations |``|
| `storage.size`| PVCs Storage Size |`400Mi`|
| `singleCA.enabled`| Enable single CA |`false`|
| `singleCA.crl.cronJob.schedule`| crl cron job schedule policy |`* 0 * * * *`|
| `singleCA.crl.extraEnv`| crl additional container env vars |``|
| `singleCA.crl.extraEnvSecret`| crl additional container env vars from pre-existing secret |``|
| `singleCA.crl.resources`| crl container resource limits |``|
| `singleCA.crl.config`| override the default crl script to retrieve the crl.pem |`see values.yaml`|
| `singleCA.crl.url`| set the url where crl.pem is located (MANDATORY) |``|
| `singleCA.crl.asSidecar`| configure crl updater with Kubernetes CronJob instead of pod sidecar (may not work with multi zone) |`false`|
| `singleCA.crl.cronJob.schedule`| define CronJob schedule |`0 * * * *`|
| `singleCA.crl.cronJob.failedJobsHistoryLimit`| puppetserver crl  CronJob failedJobsHistoryLimit |`2`|
| `singleCA.crl.cronJob.successfulJobsHistoryLimit`| puppetserver crl  CronJob successfulJobsHistoryLimit |`2`|
| `singleCA.crl.image`| crl updater container image |`puppet/r10k`|
| `singleCA.crl.tag`| crl updater container image tag |`3.15.2`|
| `singleCA.crl.imagePullPolicy`| crl updater container image pull policy |`IfNotPresent`|
| `singleCA.crl.resources`| crl updater container ressources |``|
| `singleCA.puppetdb.overrideHostname`| override the puppetdb hostname, needed when using CA where you can't add private SAN name |``|
| `singleCA.certificates.existingSecret.puppetserver`| existing k8s secret that holds `ca.pem`, `puppet.pem` & `puppet.key` |``|
| `singleCA.certificates.existingSecret.puppetdb`| existing k8s secret that holds `ca.pem`, `puppetdb.pem` & `puppetdb.key` |``|
| `metrics.prometheus.enabled` | enable prometheus exporter | `false` |
| `metrics.prometheus.image` | puppetdb exporter image | `camptocamp/prometheus-puppetdb-exporter` |
| `metrics.prometheus.tag` | puppetdb exporter tag | `1.1.0` |
| `metrics.prometheus.imagePullPolicy` | puppetdb exporter pull policy | `IfNotPresent` |
| `metrics.prometheus.port` | puppetdb exporter svc exposed ports | `9635` |
| `metrics.prometheus.resources` | puppetdb exporter container resource limits | `` |
| `metrics.prometheus.extraEnv` | puppetdb exporter additional container env vars | `` |
| `metrics.prometheus.extraEnvSecret` | puppetdb exporter additional container env vars from pre-existing secret | `` |
| `metrics.prometheus.metricRelabelings` | relabel prometheus metrics | `` |
| `metrics.prometheus.relabelings` | rewrite the label set of a target before it gets scraped | `` |
| `metrics.prometheus.jobLabel` | The label to use to retrieve the job name from. | `puppetdb` |
| `metrics.prometheus.interval` | Interval between consecutive scrapes | `30s` |
| `metrics.prometheus.honorLabels` | HonorLabels chooses the metric’s labels on collisions with target labels. | `true` |
| `metrics.prometheus.disableAPICheck` |  | `` |
| `metrics.prometheus.scrapeTimeout` | Timeout after which the scrape is ended If not specified, the Prometheus global scrape interval is used. | `` |
| `metrics.prometheus.honorTimestamps` | controls whether Prometheus respects the timestamps present in scraped data. | `` |
| `metrics.prometheus.enableHttp2` | Whether to enable HTTP2. | `` |
| `metrics.prometheus.followRedirects` | specifies whether the client should follow HTTP 3xx redirects. | `` |
| `metrics.prometheus.additionalLabels` | puppetdb exporter additional service monitor labels | `` |
| `metrics.prometheus.namespace` | puppetdb exporter service monitor if different of puppet namespace | `` |
| `metrics.prometheus.namespaceSelector` | Selector to select which namespaces the Endpoints objects are discovered from. | `` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --namespace puppetserver --name puppetserver puppet/puppetserver --set puppetserver.puppeturl='https://github.com/$SOMEUSER/puppet.git',hiera.hieradataurl='https://github.com/$SOMEUSER/hieradata.git'
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
helm install --namespace puppetserver --name puppetserver puppet/puppetserver -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Testing Helm Chart (in progress)
https://github.com/quintush/helm-unittest/

It would be great to test all ressources to avoid regression in the future

run test:
```
helm unittest . -3
```

## Testing the Deployed Chart Resources

```bash
kubectl port-forward -n puppetserver svc/agents-to-puppet 8140:8140 &
kubectl port-forward -n puppetserver svc/puppet-compilers 8141:8140 &

TIME_NOW="$(date +"%Y%m%dT%H%M")"
cp "/etc/hosts"{,.backup_"$TIME_NOW"}
echo '127.0.0.1 puppet agents-to-puppet puppet-compilers' >> /etc/hosts
# if Ingress is used, e.g.
# INGRESS_IP="$(kubectl -n puppetserver get ingress | grep '\-masters' | tr -s " " | cut -d' ' -f4 | cut -d',' -f1)"
# echo "$INGRESS_IP" puppet.local.masters puppet.local.compilers >> /etc/hosts

docker run -dit --network host --name goofy_xtigyro --entrypoint /bin/bash puppet/puppet-agent
docker exec -it goofy_xtigyro bash
puppet agent -t --server puppet --masterport 8140 --waitforcert 15 --summarize --certname ubuntu-goofy_xtigyro
puppet agent -t --server puppet-compilers --ca_server agents-to-puppet --masterport 8141 --ca_port 8140 --summarize --certname ubuntu-goofy_xtigyro
# if Ingress is used, e.g.
# puppet agent -t --server puppet.local.compilers --ca_server puppet.local.masters --masterport 443 --ca_port 443 --summarize --certname ubuntu-goofy_xtigyro
puppet agent -t --server puppet-compilers --masterport 8141 --summarize --certname ubuntu-goofy_xtigyro
exit
docker rm -f goofy_xtigyro

docker run -dit --network host --name buggy_xtigyro --entrypoint /bin/bash puppet/puppet-agent
docker exec -it buggy_xtigyro bash
puppet agent -t --server puppet-compilers --ca_server agents-to-puppet --masterport 8141 --ca_port 8140 --summarize --certname ubuntu-buggy_xtigyro
puppet agent -t --server puppet-compilers --masterport 8141 --summarize --certname ubuntu-buggy_xtigyro
# if Ingress is used, e.g.
# puppet agent -t --server puppet.local.compilers --ca_server puppet.local.masters --masterport 443 --ca_port 443 --summarize --certname ubuntu-buggy_xtigyro
puppet agent -t --server puppet --masterport 8140 --waitforcert 15 --summarize --certname ubuntu-buggy_xtigyro
exit
docker rm -f buggy_xtigyro

yes | mv "/etc/hosts.backup_"$TIME_NOW"" "/etc/hosts"
unset TIME_NOW

jobs | grep 'port-forward' | grep 'puppetserver'
# [1]+  Running                 kubectl port-forward -n puppetserver svc/puppet 8140:8140 &
kill %[job_numbers_above]
```

## Credits

* [Miroslav Hadzhiev](https://www.linkedin.com/in/mehadzhiev/), Lead Author and Owner
* [David Phayanouvong](https://github.com/davidphay), Maintainer
* [Pupperware Team](mailto:pupperware@puppet.com), Co-Author and Owner
* [Morgan Rhodes](mailto:morgan@puppet.com), Maintainer
* [Sean Conley](https://www.linkedin.com/in/seanconley/), Maintainer
* [Raphaël Pinson](https://github.com/raphink), Maintainer
* [Reinier Schoof](https://github.com/skoef), Maintainer
* [Niels Højen](https://github.com/nielshojen), Maintainer
* [Scott Cressi](https://www.linkedin.com/in/scottcressi/), Co-Author
* [Linas Daneliukas](https://github.com/ldaneliukas), Maintainer
* [Anthony Somerset](https://github.com/anthonysomerset), Maintainer
* [Kai Sisterhenn](https://www.sistason.de/), Contributor
* [chwehrli](https://github.com/chwehrli), Contributor
* [Hryhorii Didenko](https://github.com/HryhoriiDidenko), Contributor
* [John Stewart](https://github.com/jstewart612), Contributor
* [Erlon Pinheiro](https://github.com/erlonpinheiro), Contributor
* [Manasseh MMadu](https://github.com/mensaah), Contributor
* [Aidan](https://github.com/artificial-aidan), Contributor
* [Aurélien Le Clainche](https://www.linkedin.com/in/aurelien-le-clainche/), Contributor
* [Simon Fuhrer](https://github.com/simonfuhrer), Contributor
* [Kevin Harrington](https://github.com/ke5C2Fin), Contributor
* [Grégoire Menuel](https://github.com/gmenuel), Contributor
* [Jean-François Roche](https://github.com/jfroche), Contributor
* [Alexander Kiryushin](https://github.com/akiryushin), Contributor
* [Ben Feld](https://github.com/rootshellz), Contributor
* [Julien Godin](https://github.com/JGodin-C2C), Contributor
* [Diego Abelenda](https://github.com/dabelenda), Contributor
* [Johann Agnarsson](https://github.com/johannagnarsson), Contributor
