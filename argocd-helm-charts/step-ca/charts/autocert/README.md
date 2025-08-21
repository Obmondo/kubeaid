# Autocert

A kubernetes add-on that automatically injects TLS/HTTPS certificates into your
containers.

To learn more, visit https://github.com/smallstep/certificates/tree/master/autocert.

## TL;DR

```console
helm install autocert smallstep/autocert
kubectl label namespace default autocert.step.sm=enabled
```

## Prerequisites

- Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release smallstep/autocert
```

The command deploys Autocert on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

By default `autocert` helm chart installs a new `step-certificates` deployment.
But if you already have an instance of `step-certificates` running you can
configure it with autocert setting the values in the `ca` block like this:

```yaml
ca:
  url: https://ca.example.com
  # provisioner is the provisioner name and password that autocert will use
  provisioner:
    name: admin
    password: my-plaintext-password
  # certs is the configmap in yaml that should contain the CA root certificate.
  certs:
    root_ca.crt: |-
      -----BEGIN CERTIFICATE-----
      MIIBdjCCAR2gAwIBAgIQNFvgRJo4ZuvaRquC9gB3WTAKBggqhkjOPQQDAjAaMRgw
      FgYDVQQDEw9FeGFtcGxlIFJvb3QgQ0EwHhcNMjExMjEzMjMxNTU4WhcNMzExMjEx
      MjMxNTU4WjAaMRgwFgYDVQQDEw9FeGFtcGxlIFJvb3QgQ0EwWTATBgcqhkjOPQIB
      BggqhkjOPQMBBwNCAAQlQRnmP9NZ2/L1iMWE1vGwOraPR3hUeashSdIWZk+snrQG
      Mt+DXBEz8AxlV5+nNtncYErtzIV8exX+fY7V8agVo0UwQzAOBgNVHQ8BAf8EBAMC
      AQYwEgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQUxjwLhVkVREOolv5CA/J1
      QQ6SqhowCgYIKoZIzj0EAwIDRwAwRAIgf0MmZJhkAdyXscYQXLANdMUKJXx/JPjL
      XwH5kIIJvB0CIB+aMuA8aFpK/Ld1hkqrdzuvCLiD3cSaOAFzNJqFdCuo
      -----END CERTIFICATE-----
  # config is the configmap in yaml to use. This is currently optional only.
  config:
    defaults.json: |-
      {}
```

And then install autocert using a config.yaml like the above one, and setting
the value `step-certificates.enabled` to `false`:

```console
helm install --set step-certificates.enabled=false -f config.yaml my-release smallstep/autocert
```

> **Note**: Future version of the autocert helm-chart will not install
> step-certificates and it will require these values.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Enable Autocert (per namespace)

To enable Autocert for a namespace it must be labelled
`autocert.step.sm=enabled`.

To label the default namespace run:

```console
kubectl label namespace default autocert.step.sm=enabled
```

To check which namespaces have Autocert enabled run:

```console
$ kubectl get namespace -L autocert.step.sm
NAME          STATUS   AGE   AUTOCERT.STEP.SM
default       Active   59m   enabled
...
```

## Configuration

The following table lists the configurable parameters of the Autocert chart and
their default values.

| Parameter                                  | Description                                                                       | Default                                       |
|--------------------------------------------|-----------------------------------------------------------------------------------|-----------------------------------------------|
| `replicaCount`                             | Number of Autocert replicas                                                       | `1`                                           |
| `nameOverride`                             | Overrides the name of the chart                                                   | `""`                                          |
| `fullnameOverride`                         | Overrides the full name of the chart                                              | `""`                                          |
| `service.type`                             | Service type                                                                      | `ClusterIP`                                   |
| `service.port`                             | Incoming port to access Autocert                                                  | `443`                                         |
| `service.targetPort`                       | Internal port where Autocert runs                                                 | `4443`                                        |
| `autocert.image.repository`                | Repository of the Autocert image                                                  | `cr.step.sm/smallstep/autocert-controller`    |
| `autocert.image.tag`                       | Tag of the Autocert image                                                         | `0.12.2`                                      |
| `autocert.image.pullPolicy`                | Autocert image pull policy                                                        | `IfNotPresent`                                |
| `autocert.label`                           | Label uses to enable Autocert in a namespaces (should not be changed)             | `autocert.step.sm`                            |
| `autocert.logFormat`                       | Log format, `json` or `text`                                                      | `json`                                        |
| `autocert.restrictCertificatesToNamespace` | If certificate names are restricted to the namespace                              | `false`                                       |
| `autocert.closterDomain`                   | Cluster domain name                                                               | `cluster.local`                               |
| `autocert.certLifetime`                    | Certificate lifetime                                                              | `24h`                                         |
| `autocert.resources`                       | CPU/memory resource requests/limits (YAML)                                        | `{requests: {cpu: 100m, memory: 20Mi}}`       |
| `autocert.nodeSelector`                    | Node labels for pod assignment (YAML)                                             | `{}`                                          |
| `autocert.tolerations`                     | Toleration labels for pod assignment (YAML)                                       | `[]`                                          |
| `autocert.affinity`                        | Affinity settings for pod assignment (YAML)                                       | `{}`                                          |
| `bootstrapper.image.repository`            | Repository of the Autocert bootstrapper image                                     | `cr.step.sm/smallstep/autocert-bootstrapper`  |
| `bootstrapper.image.tag`                   | Tag of the Autocert bootstrapper image                                            | `0.12.2`                                      |
| `bootstrapper.image.pullPolicy`            | Autocert bootstrapper image pull policy                                           | `IfNotPresent`                                |
| `bootstrapper.resources`                   | CPU/memory resource requests/limits (YAML)                                        | `{}`                                          |
| `renewer.image.repository`                 | Repository of the Autocert renewer image                                          | `cr.step.sm/smallstep/autocert-renewer`       |
| `renewer.image.tag`                        | Tag of the Autocert renewer image                                                 | `0.12.2`                                      |
| `renewer.image.pullPolicy`                 | Autocert renewer image pull policy                                                | `IfNotPresent`                                |
| `renewer.resources`                        | CPU/memory resource requests/limits (YAML)                                        | `{}`                                          |
| `ingress.enabled`                          | If true Autocert ingress will be created                                          | `false`                                       |
| `ingress.annotations`                      | Autocert ingress annotations (YAML)                                               | `{}`                                          |
| `ingress.hosts`                            | Autocert ingress hostNAMES (YAML)                                                 | `[]`                                          |
| `ingress.tls`                              | Autocert ingress TLS configuration (YAML)                                         | `[]`                                          |
| `step-certificates.enabled`                | Enables the installation of the `step-certificates` sub-chart                     | `true`                                        |
| `step-certificates.autocert.enabled`       | Enables autocert in `step-certificates` sub-chart                                 | `true`                                        |
| `ca.url`                                   | Sets a custom CA URL, to be used with an existing `step-certificates`             | `""`                                          |
| `ca.provisioner.name`                      | The provisioner name to use                                                       | `""`                                          |
| `ca.provisioner.password`                  | The plaintext version of provisioner password                                     | `""`                                          |
| `ca.certs`                                 | The files to write in the certs configmap, it should contain the root_ca.crt      | `""`                                          |
| `ca.config`                                | The files to write in the config configmap, it might contain a defaults.json      | `{}`                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
helm install my-release \
  --set autocert.logFormat=text,step-certificates.ca.name=Foo \
  autocert
```

The above command sets the Autocert provisioner `Foo` with the key password
`secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml autocert
```

> **Tip**: You can use the default [values.yaml](values.yaml)
