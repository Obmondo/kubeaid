<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

<h1>Getting started</h1>

This documentation lets you create an openDesk evaluation instance on your Kubernetes cluster.

<!-- TOC -->
* [Requirements](#requirements)
* [Customize environment](#customize-environment)
  * [DNS](#dns)
  * [Domain](#domain)
    * [Apps](#apps)
  * [Private registries](#private-registries)
  * [Cluster capabilities](#cluster-capabilities)
    * [Service](#service)
    * [Networking](#networking)
    * [Ingress](#ingress)
    * [Container runtime](#container-runtime)
    * [Volumes](#volumes)
  * [Customize deployment](#customize-deployment)
  * [Connectivity](#connectivity)
    * [Ports](#ports)
      * [Web-based user interface](#web-based-user-interface)
      * [Mail clients](#mail-clients)
    * [Mail/SMTP configuration](#mailsmtp-configuration)
    * [TURN configuration](#turn-configuration)
    * [Certificate issuer](#certificate-issuer)
  * [Password seed](#password-seed)
  * [Install](#install)
  * [Install single app](#install-single-app)
  * [Install single release/chart](#install-single-releasechart)
* [Access deployment](#access-deployment)
  * [Using from external repository](#using-from-external-repository)
* [Uninstall](#uninstall)
<!-- TOC -->

Thanks for looking into the openDesk Getting Started guide. This document covers essential configuration steps to
deploy openDesk onto your Kubernetes infrastructure.

# Requirements

Detailed system requirements are covered on the [requirements](./docs/requirements.md) page.

# Customize environment

Before deploying openDesk, you must configure the deployment to fit your environment.
To keep your deployment up to date, we recommend customizing in `dev`, `test`, or `prod` and not in `default` environment
files.

> All configuration options and their default values can be found in files at [`helmfile/environments/default/`](../helmfile/environments/default/)

For the following guide, we will use `dev` as environment where variables can be set in
`helmfile/environments/dev/values.yaml.gotmpl`.

## DNS

The deployment is designed to deploy each application/service under a dedicated subdomain.
For your convenience, we recommend creating a `*.domain.tld` A-Record for your cluster Ingress Controller; otherwise, you must create an A-Record for each subdomain.

| Record name                   | Type | Value                                              | Additional information                                            |
|-------------------------------|------|----------------------------------------------------|-------------------------------------------------------------------|
| *.domain.tld                  | A    | IPv4 address of your Ingress Controller            |                                                                   |
| *.domain.tld                  | AAAA | IPv6 address of your Ingress Controller            |                                                                   |
| mail.domain.tld               | A    | IPv4 address of your postfix NodePort/LoadBalancer | Optional, mail should directly be delivered to openDesk's Postfix |
| mail.domain.tld               | AAAA | IPv6 address of your postfix NodePort/LoadBalancer | Optional, mail should directly be delivered to openDesk's Postfix |
| domain.tld                    | MX   | `10 mail.domain.tld`                               |                                                                   |
| domain.tld                    | TXT  | `v=spf1 +a +mx +a:mail.domain.tld ~all`            | Optional, use proper MTA record if present                        |
| _dmarc.domain.tld             | TXT  | `v=DMARC1; p=quarantine`                           | Optional                                                          |
| default._domainkey.domain.tld | TXT  | `v=DKIM1; k=rsa; h=sha256; ...`                    | Optional, DKIM settings                                           |
| _caldavs._tcp.domain.tld      | SRV  | 10 1 443 dav.domain.tld.                           | Optional, CalDav auto discovery                                   |
| _caldav._tcp.domain.tld       | SRV  | 10 1  80 dav.domain.tld.                           | Optional, CalDav auto discovery                                   |
| _carddavs._tcp.domain.tld     | SRV  | 10 1 443 dav.domain.tld.                           | Optional, CardDav auto discovery                                  |
| _carddav._tcp.domain.tld      | SRV  | 10 1  80 dav.domain.tld.                           | Optional, CardDav auto discovery                                  |

## Domain

A list of all subdomains can be found in `helmfile/environments/default/global.yaml.gotmpl`.

All subdomains can be customized. For example, _Nextcloud_ can be changed to `files.domain.tld` in `dev` environment:

```yaml
global:
  hosts:
    nextcloud: "files"
```

The domain has to be set either via `dev` environment:

```yaml
global:
  domain: "domain.tld"
```

or alternatively via environment variable:

```shell
export DOMAIN=domain.tld
```

### Apps

Depending on your ideal openDesk deployment, you may wish to disable or enable certain apps.
All available apps and their default values are located in `helmfile/environments/default/opendesk_main.yaml.gotmpl`.

| Component            | Name                        | Default | Description                    |
| -------------------- | --------------------------- | ------- | ------------------------------ |
| Certificates         | `apps.certificates.enabled`      | `true`  | TLS certificates               |
| ClamAV (Distributed) | `apps.clamavDistributed.enabled` | `false` | Antivirus engine               |
| ClamAV (Simple)      | `apps.clamavSimple.enabled`      | `true`  | Antivirus engine               |
| Collabora            | `apps.collabora.enabled`         | `true`  | Weboffice                      |
| CryptPad             | `apps.cryptpad.enabled`          | `true`  | Weboffice                      |
| dkimpy               | `apps.dkimpy.enabled`            | `false` | Postfix milter for DKIM        |
| Dovecot              | `apps.dovecot.enabled`           | `true`  | Mail backend                   |
| Element              | `apps.element.enabled`           | `true`  | Secure communications platform |
| Home                 | `apps.home.enabled`              | `true`  | Base domain portal redirect    |
| Jitsi                | `apps.jitsi.enabled`             | `true`  | Videoconferencing              |
| MariaDB              | `apps.mariadb.enabled`           | `true`  | Database                       |
| Memcached            | `apps.memcached.enabled`         | `true`  | Cache Database                 |
| MinIO                | `apps.minio.enabled`             | `true`  | Object Storage                 |
| Nextcloud            | `apps.nextcloud.enabled`         | `true`  | File share                     |
| Nubus                | `apps.nubus.enabled`             | `true`  | Identity Management & Portal   |
| OpenProject          | `apps.openproject.enabled`       | `true`  | Project management             |
| OX App Suite         | `apps.oxAppSuite.enabled`        | `true`  | Groupware                      |
| Postfix              | `apps.postfix.enabled`           | `true`  | MTA                            |
| PostgreSQL           | `apps.postgresql.enabled`        | `true`  | Database                       |
| Redis                | `apps.redis.enabled`             | `true`  | Cache Database                 |
| XWiki                | `apps.xwiki.enabled`             | `true`  | Knowledge management           |

For example, Jitsi can be disabled like this:

```yaml
apps:
  jitsi:
    enabled: false
```

## Private registries

By default, Helm charts and container images are fetched from OCI registries. These registries can be found in most cases
in the [openDesk/component section on openCode](https://gitlab.opencode.de/bmi/opendesk/components).

For untouched upstream artifacts that do not belong to a functional component's core, we use upstream registries
like Docker Hub.

Doing a test deployment will be fine with this setup. In case you want to deploy multiple times a day
and fetch from the same IP address, you might run into rate limits at Docker Hub. In that case, and in case you
prefer the use of a private image registry, you can configure these in
[your target environment](../helmfile/environments/dev/values.yaml.gotmpl.sample) by setting
- `global.imageRegistry` for a private image registry and
- `global.helmRegistry` for a private Helm chart registry.

```yaml
global:
  imageRegistry: "my_private_registry.domain.tld"
```

alternatively, you can use an environment variable:

```shell
export PRIVATE_IMAGE_REGISTRY_URL=my_private_registry.domain.tld
```

or for more granular control over repository overrides per registry (rewrites):

```yaml
repositories:
  image:
    dockerHub: "my_private_registry.domain.tld/docker.io/"
    registryOpencodeDe: "my_private_registry.domain.tld/registry.opencode.de/"
```

If authentication is required, you can reference `imagePullSecrets` as follows:

```yaml
global:
  imagePullSecrets:
    - "external-registry"
```

## Cluster capabilities

### Service

Some apps, like Jitsi and Dovecot, require HTTP and external TCP connections.
These apps create a Kubernetes service object.
You can configure whether `NodePort` (for on-premises), `LoadBalancer` (for cloud), or `ClusterIP` (to disable) should be
used:

```yaml
cluster:
  service:
    type: "NodePort"
```

### Networking

If your cluster does not have the default `cluster.local` domain configured, you need to provide the domain via:

```yaml
cluster:
  networking:
    domain: "acme.internal"
```

If your cluster does not have the default `10.0.0.0/8` CIDR configured, you need to provide the CIDR via the following:

```yaml
cluster:
  networking:
    cidr:
      - "127.0.0.0/8"
```

If your load balancer / reverse proxy IPs are not already included in the above `cidr` you need to
explicitly configure their related IPs or IP ranges:

```yaml
cluster:
  networking:
    incomingCIDR:
      - "172.16.0.0/12"
```

### Ingress

The default value for the `ingressClassName` in openDesk is set to `nginx`. This prevents fallback to the
cluster’s default ingress class, since the Helm charts used by openDesk components are not consistently aligned in
how they handle a missing or empty `ingressClassName`. In case you are using a non-standard `ingressClassName` for
your `ingress-nginx` controller you have to configure it as follows:

```yaml
ingress:
  ingressClassName: "nginx"
```

> **Note**<br>
> Currently, the only supported ingress controller is `ingress-nginx`
> (see [requirements.md](./docs/requirements.md) for reference).

### Container runtime

Some apps require specific configurations for the container runtime. You can set your container runtime like `cri-o`,
`containerd` or `docker` by using the following attribute:

```yaml
cluster:
  container:
    engine: "containerd"
```

### Volumes
The StorageClass must be set using the following attribute:

```yaml
persistence:
  storageClassNames:
    RWX: "my-read-write-many-class"
    RWO: "my-read-write-once-class"
```

`RWX` is optional and requires that your cluster has a `ReadWriteMany` volume provisioner. If you can make use
of it, it largely benefits the distribution and scaling of apps. By default, only `ReadWriteOnce` is enabled.
To enable `ReadWriteMany` you can use the following attribute:

```yaml
cluster:
  persistence:
    readWriteMany: true
```

## Customize deployment

While openDesk configures the applications with meaningful defaults, you can check [functional.md](./docs/functional.md) if you want to change these defaults to better match your use case.

## Connectivity

### Ports

> **Note**<br>
> If you use `NodePort` for service exposure, you must check your deployment for the actual ports and ensure they are opened where necessary.

#### Web-based user interface

To use the openDesk functionality with its web-based user interface, you need to expose the following ports publicly:

| Component          | Description             |  Port | Type |
| ------------------ | ----------------------- | ----: | ---: |
| openDesk           | Kubernetes Ingress      |    80 |  TCP |
| openDesk           | Kubernetes Ingress      |   443 |  TCP |
| Jitsi Video Bridge | ICE Port for video data | 10000 |  UDP |

#### Mail clients

To connect with mail clients like [Thunderbird](https://www.thunderbird.net/), the following ports need to be publicly exposed:

| Component          | Description             |  Port | Type |
| ------------------ | ----------------------- | ----: | ---: |
| Dovecot            | IMAPS                   |   993 |  TCP |
|                    | POP3S                   |   995 |  TCP |
| Postfix            | SMTP                    |    25 |  TCP |
|                    | SMTPS                   |   587 |  TCP |

### Mail/SMTP configuration

To use the full potential of the openDesk, you need to set up an SMTP relay that allows sending emails from
the whole subdomain. The following attribute can be set:

```yaml
smtp:
  host: "mail.open.desk"
  username: "openDesk"
  password: "secret"
```

Enabling DKIM signing of emails helps to reduce spam and increases trust.
openDesk ships dkimpy-milter as Postfix milter for signing emails. The following attributes can be set:

```yaml
apps:
  dkimpy:
    enabled: true
smtp:
  dkim:
    key:
      value: "HzZs08QF1O7UiAkcM9T3U7rePPECtSFvWZIvyKqdg8E="
    selector: "default"
    useED25519: true # when false, RSA is used
```

### TURN configuration

Some components (Jitsi, Element) use a TURN server for direct communication. You can configure your own TURN server with
these options:

```yaml
turn:
  transport: "udp" # or tcp
  credentials: "secret"
  server:
    host: "turn.open.desk"
    port: "3478"
  tls:
    host: "turns.open.desk"
    port: "5349"
```

### Certificate issuer

As mentioned in [requirements](requirements.md#certificate-management), you can provide your own valid certificate. A TLS type
secret named `opendesk-certificates-tls` must be present in the application namespace. For deployment, you can
turn off `Certificate` resource creation with:

```yaml
apps:
  certificates:
    enabled: false
```

If you want to leverage `cert-manager.io` to handle certificates, like `Let's encrypt`, you need to provide the
configured cluster issuer:

```yaml
certificate:
  issuerRef:
    name: "letsencrypt-prod"
```

Additionally, it is possible to request wildcard certificates with:

```yaml
certificate:
  wildcard: true
```

## Password seed

All secrets are generated from a master password via [Master Password (algorithm)](https://en.wikipedia.org/wiki/Master_Password_(algorithm)).
To prevent others from using your openDesk instance, you must set your individual master password via:

```shell
export MASTER_PASSWORD="your_individual_master_password"
```

> **Note**<br>
> Currently a [documented](https://docs.software-univention.de/nubus-kubernetes-operation/1.x/en/configuration/nats.html#configure-the-secrets) upstream [bug](https://forge.univention.org/bugzilla/show_bug.cgi?id=58357) causes a failure when passwords/secrets beginning with certain numbers are using for the Nubus subcomponent NATS.
> With openDesk 1.6.0 an update-aware workaround was implemented that prefixes the affected secrets in the openDesk included `secrets.yaml.gotmpl` that derives all secrets from the previously mentioned `MASTER_PASSWORD`.
> If you are using externally provided passwords/secrets make sure that none of the ones listed below are starting with a number:
>
> - `secrets.nubus.provisioning.api.natsPassword`
> - `secrets.nubus.provisioning.dispatcherNatsPassword`
> - `secrets.nubus.provisioning.prefillNatsPassword`
> - `secrets.nubus.provisioning.udmListenerNatsPassword`
> - `secrets.nubus.provisioning.udmTransformerNatsPassword`
> - `secrets.nats.natsAdminPassword`

## Install

After setting your environment-specific values in `dev` environment, you can start deployment by:

```shell
helmfile apply -e dev -n <NAMESPACE> [-l <label>] [--suppress-diff]
```

**Arguments:**

- `-e <env>`: Environment name out of `default`, `dev`, `test`, `prod`
- `-n <namespace>`: Kubernetes namespace
- `-l <label>`: Label selector
- `--suppress-diff`: Disable diff printing

## Install single app

You can also install or upgrade only a single app like Collabora, either by using a label selector:

```shell
helmfile apply -e dev -n <NAMESPACE> -l component=collabora
```

or by switching to the apps' directory (faster) and install or upgrade from there directly:

```shell
cd helmfile/apps/collabora
helmfile apply -e dev -n <NAMESPACE>
```

## Install single release/chart

Instead of iterating through all services, you can also deploy a single release like `mariadb` by executing the following:

```shell
helmfile apply -e dev -n <NAMESPACE> -l name=mariadb
```

# Access deployment

When all apps are successfully deployed, and their Pod status is `Running` or `Succeeded`, you can navigate to

```text
https://portal.domain.tld
```

If you change the subdomain of `nubus`, you must replace the subdomain of `portal` with the same subdomain.

**Credentials:**

openDesk deploys with the standard user account `Administrator`, the password for which can be retrieved as follows:

```shell
# Set your namespace
NAMESPACE=<your_namespace>

# Get password for IAM "Administrator" account
kubectl -n ${NAMESPACE} get secret ums-nubus-credentials -o jsonpath='{.data.administrator_password}' | base64 -d
```

Using the aforementioned account, you can either create new accounts manually or make use of the
[openDesk User Importer](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/user-import/)
script or container.

In the following snippet, after defining the values of the first three lines and executing the command,
you get two accounts, `default` and `default-admin`:

```shell
ADMINISTRATOR_PASSWORD=<your_administrator_password_see_above>
DOMAIN=<your_domain>
DEFAULT_USERS_PASSWORD=<password_for_the_created_default_accounts>
docker run --rm registry.opencode.de/bmi/opendesk/components/platform-development/images/user-import:3.0.0 \
  ./user_import_udm_rest_api.py \
    --import_domain ${DOMAIN} \
    --udm_api_password ${ADMINISTRATOR_PASSWORD} \
    --set_default_password ${DEFAULT_USERS_PASSWORD} \
    --import_filename template.ods \
    --create_admin_accounts True
```

## Using from external repository

Referring to `./helmfile_generic.yaml.gotmpl` from an external
directory or repository is possible. The `helmfile.yaml.gotmpl` that refers to
`./helmfile_generic.yaml.gotmpl` may define custom environments. These custom
environments may overwrite specific configuration values. These
configuration values are:

* `global.domain`
* `global.helmRegistry`
* `global.master_password`

# Uninstall

You can uninstall the deployment by executing the following:

```shell
helmfile destroy -n <NAMESPACE>
```

> **Note**<br>
> Not all Jobs, PersistentVolumeClaims, or Certificates are deleted; you have to delete them manually

**'Sledgehammer destroy'** - for fast development turn-around times (at your own risk):

```shell
NAMESPACE=your-namespace

# Uninstall all Helm charts
for OPENDESK_RELEASE in $(helm ls -n ${NAMESPACE} -aq); do
  helm uninstall -n ${NAMESPACE} ${OPENDESK_RELEASE};
done

# Delete leftover resources
kubectl delete pvc --all --namespace ${NAMESPACE};
kubectl delete jobs --all --namespace ${NAMESPACE};
kubectl delete configmaps --all --namespace ${NAMESPACE};
```

> **Warning**<br>
> Without specifying a `--namespace` flag, or by leaving it empty, cluster-wide components will get deleted!
