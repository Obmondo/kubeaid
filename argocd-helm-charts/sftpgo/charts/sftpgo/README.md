# sftpgo

Full-featured and highly configurable SFTP, HTTP/S, FTP/S and WebDAV server.

**Homepage:** <https://sftpgo.com>

## TL;DR;

```bash
helm install --generate-name --wait oci://ghcr.io/sftpgo/helm-charts/sftpgo
```

## Configuration

SFTPGo has an extensive set of [configuration](https://docs.sftpgo.com/latest/config-file/) options allowing you to control the large set of features it provides.

The following options are available to configure SFTPGo when installing it with this chart.

**Note:** environmental configurations (like port bindings, certain directories, etc) are configured by the chart or the container image using flags and environment variables and they cannot be configured using a config file.

### values.yaml

Setting the `config` key in the values file is the easiest way to configure SFTPGo:

```yaml
config:
    sftpd:
        max_auth_tries: 10
```

### Custom volume mount

A custom configuration file can be mounted using the `volumes` and `volumeMounts` keys (see [Values](#values)).

By default, SFTPGo looks at the following locations for configuration (in the order of precedence):

- `/var/lib/.config/sftpgo`
- `/etc/sftpgo` (already mounted by this chart)

You can mount a config map or a secret to `/var/lib/.config/sftpgo`.

**Note:** this method will override all configuration set in `values.yaml`.

**Example:**

```yaml
# configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: custom-sftpgo-config
data:
  sftpgo.yaml: |-
    sftpd:
        max_auth_retries: 10
```

```yaml
# values.yaml

volumes:
  - name: custom-config # config is already taken
    configMap:
      name: custom-sftpgo-config

volumeMounts:
  - name: custom-config # config is already taken
    mountPath: /var/lib/sftpgo/.config/sftpgo
```

Alternatively, you can mount the config file to any arbitrary location (except `/etc/sftpgo`) and set the `SFTPGO_CONFIG_FILE` environment variable (using `env` or `envFrom`, see [Values](#values)).

### Custom services

The primary service created by the chart includes every enabled server (including HTTP and telemetry).
This can be a problem when you want to expose specific (but not all) servers to the internet using a `LoadBalancer` type service.

The `services` option in the values file allows you to create custom services enabling specific server ports.

The following example exposes the SFTP server (and **only** the SFTP server) using a `LoadBalancer` service:

```yaml
services:
  sftp-public:
    annotations:
      external-dns.alpha.kubernetes.io/hostname: sftp.mydomain.com.
    type: LoadBalancer
    ports:
      sftp: 22
```

Additional services accept the same options as the `service` option in the values file and
require at least one port.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) configuration. See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#scheduling) for details. |
| api.ingress.annotations | object | `{}` | Annotations to be added to the ingress. |
| api.ingress.className | string | `""` | Ingress [class name](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class). |
| api.ingress.enabled | bool | `false` | Enable [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| api.ingress.hosts | list | See [values.yaml](values.yaml). | Ingress host configuration. |
| api.ingress.tls | list | See [values.yaml](values.yaml). | Ingress TLS configuration. |
| autoscaling | object | Disabled by default. | Autoscaling configuration (see [values.yaml](values.yaml) for details). |
| config | object | `{}` | Application configuration. See the [official documentation](https://docs.sftpgo.com/latest/config-file/). |
| deploymentAnnotations | object | `{}` | Annotations to be added to deployment. |
| deploymentLabels | object | `{}` | Labels to be added to deployment. |
| deploymentStrategy | object | `{}` | Define the [strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) to replace old Pods by new ones during updates. |
| env | object | `{}` | Additional environment variables passed directly to containers using a simplified key-value syntax. |
| envFrom | list | `[]` | Additional environment variables mounted from [secrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables) or [config maps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables). See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables) for details. |
| envVars | list | `[]` | Additional environment variables passed directly to containers. See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables) for details. |
| ftpd.enabled | bool | `false` | Enable FTP service. |
| ftpd.port | int | `2021` | Container FTP port. Set to 0 to disable the service. The 'enabled' flag may be removed in the future in favor of this setting. |
| fullnameOverride | string | `""` | A name to substitute for the full names of resources. |
| hostNetwork | bool | `false` | Run pods in the host network of nodes. Warning: The use of host network is [discouraged](https://kubernetes.io/docs/concepts/configuration/overview/#services). Make sure to use it only when absolutely necessary. |
| httpd.enabled | bool | `true` | Enable HTTP service. |
| httpd.port | int | `8080` | Container HTTP port. Set to 0 to disable the service. The 'enabled' flag may be removed in the future in favor of this setting. |
| image.pullPolicy | string | `"IfNotPresent"` | [Image pull policy](https://kubernetes.io/docs/concepts/containers/images/#updating-images) for updating already existing images on a node. |
| image.repository | string | `"ghcr.io/drakkan/sftpgo"` | Name of the image repository to pull the container image from. |
| image.tag | string | `""` | Image tag override for the default value (chart appVersion). |
| imagePullSecrets | list | `[]` | Reference to one or more secrets to be used when [pulling images](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret) (from private registries). |
| initContainers | list | `[]` | Add [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) to the pod. |
| nameOverride | string | `""` | A name in place of the chart name for `app:` labels. |
| nodeSelector | object | `{}` | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) configuration. |
| persistence.enabled | bool | `false` | Enable persistent storage for the /var/lib/sftpgo directory, saving state of the default sqlite db. |
| persistence.pvc | object | `{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"5Gi"}},"storageClassName":""}` | Create the pvc desired specificiation. |
| podAnnotations | object | `{}` | Annotations to be added to pods. |
| podLabels | object | `{}` | Labels to be added to pods. |
| podSecurityContext | object | `{"fsGroup":1000}` | Pod [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod). See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#security-context) for details. |
| replicaCount | int | `1` | Number of replicas (pods) to launch. |
| resources | object | No requests or limits. | Container resource [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/). See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#resources) for details. |
| securityContext | object | `{}` | Container [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container). See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#security-context-1) for details. |
| service.annotations | object | `{}` | Annotations to be added to the service. |
| service.externalTrafficPolicy | string | `nil` | Route external traffic to node-local or cluster-wide endoints. Useful for [preserving the client source IP](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip). |
| service.labels | object | `{}` | labels to be added to the service. |
| service.loadBalancerIP | string | `nil` | Only applies when the service type is LoadBalancer. Load balancer will get created with the IP specified in this field. |
| service.loadBalancerSourceRanges | list | `[]` | If specified (and supported by the cloud provider), traffic through the load balancer will be restricted to the specified client IPs. Valid values are IP CIDR blocks. |
| service.ports.ftp.nodePort | int | `nil` | FTP node port (when applicable). |
| service.ports.ftp.passiveRange.end | int | `50020` | FTP passive range end port. |
| service.ports.ftp.passiveRange.start | int | `50000` | FTP passive range start port. |
| service.ports.ftp.port | int | `21` | FTP service port. |
| service.ports.http.nodePort | int | `nil` | REST API node port (when applicable). |
| service.ports.http.port | int | `80` | REST API service port. |
| service.ports.sftp.nodePort | int | `nil` | SFTP node port (when applicable). |
| service.ports.sftp.port | int | `22` | SFTP service port. |
| service.ports.webdav.nodePort | int | `nil` | WebDAV node port (when applicable). |
| service.ports.webdav.port | int | `81` | WebDAV service port. |
| service.sessionAffinity | string | `nil` | Enable client IP based session affinity. [More info](https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies) |
| service.type | string | `"ClusterIP"` | Kubernetes [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types). |
| serviceAccount.annotations | object | `{}` | Annotations to be added to the service account. |
| serviceAccount.create | bool | `true` | Enable service account creation. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| services | object | `{}` | Additional services exposing servers (SFTP, FTP, WebDAV, HTTP) individually. The schema matches the one under the `service` key. Additional services need at least one port. |
| sftpd.enabled | bool | `true` | Enable SFTP service. |
| sftpd.port | int | `2022` | Container SFTP port. Set to 0 to disable the service. The 'enabled' flag may be removed in the future in favor of this setting. |
| tolerations | list | `[]` | [Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for node taints. See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#scheduling) for details. |
| topologySpreadConstraints.enabled | bool | `false` | Enable pod [Topology Spread Constraints](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/). |
| topologySpreadConstraints.maxSkew | int | `1` | Degree to which pods may be unevenly distributed. |
| topologySpreadConstraints.topologyKey | string | `"topology.kubernetes.io/zone"` | The key of node labels. See https://kubernetes.io/docs/reference/kubernetes-api/labels-annotations-taints/ |
| topologySpreadConstraints.whenUnsatisfiable | string | `"DoNotSchedule"` | How to deal with a Pod if it doesn't satisfy the spread constraint. |
| ui.ingress.annotations | object | `{}` | Annotations to be added to the ingress. |
| ui.ingress.className | string | `""` | Ingress [class name](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class). |
| ui.ingress.enabled | bool | `false` | Enable [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| ui.ingress.hosts | list | See [values.yaml](values.yaml). | Ingress host configuration. |
| ui.ingress.tls | list | See [values.yaml](values.yaml). | Ingress TLS configuration. |
| volumeMounts | list | `[]` | Additional [volume mounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/). See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#volumes-1) for details. |
| volumes | list | `[]` | Additional storage [volumes](https://kubernetes.io/docs/concepts/storage/volumes/). See the [API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#volumes-1) for details. |
| webdavd.enabled | bool | `false` | Enable WebDAV service. |
| webdavd.port | int | `8081` | Container WebDAV port. Set to 0 to disable the service. The 'enabled' flag may be removed in the future in favor of this setting. |

## Attributions

This Helm chart was originally created by [@sagikazarmark](https://github.com/sagikazarmark/).
