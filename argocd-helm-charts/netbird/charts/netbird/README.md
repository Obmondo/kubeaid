# netbird

Forked from [TOT MICRO's Helm Repository](https://github.com/totmicro/helms).
![Version: 1.8.0](https://img.shields.io/badge/Version-1.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.46.0](https://img.shields.io/badge/AppVersion-0.46.0-informational?style=flat-square)

## NetBird Helm Chart

This Helm chart installs and configures the [NetBird](https://github.com/netbirdio/netbird) services within a Kubernetes cluster. The chart includes the management, signal, and relay components of NetBird, providing secure peer-to-peer network connections across various environments.

## Prerequisites

- Helm 3.x
- Kubernetes 1.19+

## Installation

To install the chart with the release name `netbird`:

```bash
helm repo add netbirdio https://netbirdio.github.io/helms
helm install netbird netbirdio/netbird
```

You can override default values by specifying a `values.yaml` file:

```bash
helm install netbird netbirdio/netbird -f values.yaml
```

### Uninstalling the Chart

To uninstall/delete the `netbird` release:

```bash
helm uninstall netbird
```

This will remove all the resources associated with the release.

## Configuration

The following table lists the configurable parameters of the NetBird Helm chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dashboard.volumeMounts | list | `[]` |  |
| dashboard.volumes | list | `[]` |  |
| dashboard.affinity | object | `{}` |  |
| dashboard.containerPort | int | `80` |  |
| dashboard.enabled | bool | `true` |  |
| dashboard.env | object | `{}` |  |
| dashboard.envFromSecret | object | `{}` |  |
| dashboard.envRaw | list | `[]` |  |
| dashboard.image.pullPolicy | string | `"IfNotPresent"` |  |
| dashboard.image.repository | string | `"netbirdio/dashboard"` |  |
| dashboard.image.tag | string | `"v2.13.1"` |  |
| dashboard.imagePullSecrets | list | `[]` |  |
| dashboard.ingress.annotations | object | `{}` |  |
| dashboard.ingress.className | string | `""` |  |
| dashboard.ingress.enabled | bool | `false` |  |
| dashboard.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| dashboard.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| dashboard.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| dashboard.ingress.tls | list | `[]` |  |
| dashboard.lifecycle | object | `{}` |  |
| dashboard.livenessProbe.httpGet.path | string | `"/"` |  |
| dashboard.livenessProbe.httpGet.port | string | `"http"` |  |
| dashboard.livenessProbe.periodSeconds | int | `5` |  |
| dashboard.nodeSelector | object | `{}` |  |
| dashboard.podAnnotations | object | `{}` |  |
| dashboard.podCommand.args | list | `[]` |  |
| dashboard.podSecurityContext | object | `{}` |  |
| dashboard.readinessProbe.httpGet.path | string | `"/"` |  |
| dashboard.readinessProbe.httpGet.port | string | `"http"` |  |
| dashboard.readinessProbe.initialDelaySeconds | int | `5` |  |
| dashboard.readinessProbe.periodSeconds | int | `5` |  |
| dashboard.replicaCount | int | `1` |  |
| dashboard.resources | object | `{}` |  |
| dashboard.securityContext | object | `{}` |  |
| dashboard.service.name | string | `"http"` |  |
| dashboard.service.port | int | `80` |  |
| dashboard.service.type | string | `"ClusterIP"` |  |
| dashboard.service.externalIPs | list | `[]` |  |
| dashboard.service.annotations | object | `{}` |  |
| dashboard.serviceAccount.annotations | object | `{}` |  |
| dashboard.serviceAccount.create | bool | `true` |  |
| dashboard.serviceAccount.name | string | `""` |  |
| dashboard.tolerations | list | `[]` |  |
| extraManifests | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| global.namespace | string | `""` |  |
| management.volumeMounts | list | `[]` |  |
| management.volumes | list | `[]` |  |
| management.affinity | object | `{}` |  |
| management.configmap | string | `""` |  |
| management.containerPort | int | `80` |  |
| management.deploymentAnnotations | object | `{}` |  |
| management.enabled | bool | `true` |  |
| management.env | object | `{}` |  |
| management.envFromSecret | object | `{}` |  |
| management.envRaw | list | `[]` |  |
| management.grpcContainerPort | int | `33073` |  |
| management.image.pullPolicy | string | `"IfNotPresent"` |  |
| management.image.repository | string | `"netbirdio/management"` |  |
| management.image.tag | string | `""` |  |
| management.imagePullSecrets | list | `[]` |  |
| management.ingress.annotations | object | `{}` |  |
| management.ingress.className | string | `""` |  |
| management.ingress.enabled | bool | `false` |  |
| management.ingress.hosts[0].host | string | `"example.com"` |  |
| management.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| management.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| management.ingress.tls | list | `[]` |  |
| management.ingressGrpc.annotations | object | `{}` |  |
| management.ingressGrpc.className | string | `""` |  |
| management.ingressGrpc.enabled | bool | `false` |  |
| management.ingressGrpc.hosts[0].host | string | `"example.com"` |  |
| management.ingressGrpc.hosts[0].paths[0].path | string | `"/"` |  |
| management.ingressGrpc.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| management.ingressGrpc.tls | list | `[]` |  |
| management.lifecycle | object | `{}` |  |
| management.livenessProbe.failureThreshold | int | `3` |  |
| management.livenessProbe.initialDelaySeconds | int | `15` |  |
| management.livenessProbe.periodSeconds | int | `10` |  |
| management.livenessProbe.tcpSocket.port | string | `"http"` |  |
| management.livenessProbe.timeoutSeconds | int | `3` |  |
| management.metrics.enabled | bool | `false` |  |
| management.metrics.port | int | `9090` |  |
| management.nodeSelector | object | `{}` |  |
| management.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| management.persistentVolume.enabled | bool | `true` |  |
| management.persistentVolume.existingPVName | string | `""` |  |
| management.persistentVolume.size | string | `"10Mi"` |  |
| management.persistentVolume.storageClass | string | `nil` |  |
| management.podAnnotations | object | `{}` |  |
| management.podCommand.args[0] | string | `"--port=80"` |  |
| management.podCommand.args[1] | string | `"--log-file=console"` |  |
| management.podCommand.args[2] | string | `"--log-level=info"` |  |
| management.podCommand.args[3] | string | `"--disable-anonymous-metrics=false"` |  |
| management.podCommand.args[4] | string | `"--single-account-mode-domain=netbird.selfhosted"` |  |
| management.podCommand.args[5] | string | `"--dns-domain=netbird.selfhosted"` |  |
| management.podSecurityContext | object | `{}` |  |
| management.readinessProbe.failureThreshold | int | `3` |  |
| management.readinessProbe.initialDelaySeconds | int | `15` |  |
| management.readinessProbe.periodSeconds | int | `10` |  |
| management.readinessProbe.tcpSocket.port | string | `"http"` |  |
| management.readinessProbe.timeoutSeconds | int | `3` |  |
| management.replicaCount | int | `1` |  |
| management.resources | object | `{}` |  |
| management.securityContext | object | `{}` |  |
| management.service.name | string | `"http"` |  |
| management.service.port | int | `80` |  |
| management.service.type | string | `"ClusterIP"` |  |
| management.service.externalIPs | list | `[]` |  |
| management.service.annotations | object | `{}` |  |
| management.serviceAccount.annotations | object | `{}` |  |
| management.serviceAccount.create | bool | `true` |  |
| management.serviceAccount.name | string | `""` |  |
| management.serviceGrpc.name | string | `"grpc"` |  |
| management.serviceGrpc.port | int | `33073` |  |
| management.serviceGrpc.type | string | `"ClusterIP"` |  |
| management.serviceGrpc.externalIPs | list | `[]` |  |
| management.serviceGrpc.annotations | object | `{}` |  |
| management.tolerations | list | `[]` |  |
| management.useBackwardsGrpcService | bool | `false` |  |
| metrics.serviceMonitor.annotations | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.jobLabel | string | `""` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.serviceMonitor.selector | object | `{}` |  |
| nameOverride | string | `""` |  |
| relay.volumeMounts | list | `[]` |  |
| relay.volumes | list | `[]` |  |
| relay.affinity | object | `{}` |  |
| relay.containerPort | int | `33080` |  |
| relay.deploymentAnnotations | object | `{}` |  |
| relay.enabled | bool | `true` |  |
| relay.env | object | `{}` |  |
| relay.envFromSecret | object | `{}` |  |
| relay.envRaw | list | `[]` |  |
| relay.image.pullPolicy | string | `"IfNotPresent"` |  |
| relay.image.repository | string | `"netbirdio/relay"` |  |
| relay.image.tag | string | `""` |  |
| relay.imagePullSecrets | list | `[]` |  |
| relay.ingress.annotations | object | `{}` |  |
| relay.ingress.className | string | `""` |  |
| relay.ingress.enabled | bool | `false` |  |
| relay.ingress.hosts[0].host | string | `"example.com"` |  |
| relay.ingress.hosts[0].paths[0].path | string | `"/relay"` |  |
| relay.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| relay.ingress.tls | list | `[]` |  |
| relay.livenessProbe.initialDelaySeconds | int | `5` |  |
| relay.livenessProbe.periodSeconds | int | `5` |  |
| relay.livenessProbe.tcpSocket.port | string | `"http"` |  |
| relay.logLevel | string | `"info"` |  |
| relay.metrics.enabled | bool | `false` |  |
| relay.metrics.port | int | `9090` |  |
| relay.nodeSelector | object | `{}` |  |
| relay.podAnnotations | object | `{}` |  |
| relay.podSecurityContext | object | `{}` |  |
| relay.readinessProbe.initialDelaySeconds | int | `5` |  |
| relay.readinessProbe.periodSeconds | int | `5` |  |
| relay.readinessProbe.tcpSocket.port | string | `"http"` |  |
| relay.replicaCount | int | `1` |  |
| relay.resources | object | `{}` |  |
| relay.securityContext | object | `{}` |  |
| relay.service.name | string | `"http"` |  |
| relay.service.port | int | `33080` |  |
| relay.service.type | string | `"ClusterIP"` |  |
| relay.service.externalIPs | list | `[]` |  |
| relay.service.annotations | object | `{}` |  |
| relay.serviceAccount.annotations | object | `{}` |  |
| relay.serviceAccount.create | bool | `true` |  |
| relay.serviceAccount.name | string | `""` |  |
| relay.tolerations | list | `[]` |  |
| signal.volumeMounts | list | `[]` |  |
| signal.volumes | list | `[]` |  |
| signal.affinity | object | `{}` |  |
| signal.containerPort | int | `80` |  |
| signal.deploymentAnnotations | object | `{}` |  |
| signal.enabled | bool | `true` |  |
| signal.image.pullPolicy | string | `"IfNotPresent"` |  |
| signal.image.repository | string | `"netbirdio/signal"` |  |
| signal.image.tag | string | `""` |  |
| signal.imagePullSecrets | list | `[]` |  |
| signal.ingress.annotations | object | `{}` |  |
| signal.ingress.className | string | `""` |  |
| signal.ingress.enabled | bool | `false` |  |
| signal.ingress.hosts[0].host | string | `"example.com"` |  |
| signal.ingress.hosts[0].paths[0].path | string | `"/signalexchange.SignalExchange"` |  |
| signal.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| signal.ingress.tls | list | `[]` |  |
| signal.livenessProbe.initialDelaySeconds | int | `5` |  |
| signal.livenessProbe.periodSeconds | int | `5` |  |
| signal.livenessProbe.tcpSocket.port | string | `"grpc"` |  |
| signal.logLevel | string | `"info"` |  |
| signal.metrics.enabled | bool | `false` |  |
| signal.metrics.port | int | `9090` |  |
| signal.nodeSelector | object | `{}` |  |
| signal.podAnnotations | object | `{}` |  |
| signal.podSecurityContext | object | `{}` |  |
| signal.readinessProbe.initialDelaySeconds | int | `5` |  |
| signal.readinessProbe.periodSeconds | int | `5` |  |
| signal.readinessProbe.tcpSocket.port | string | `"grpc"` |  |
| signal.replicaCount | int | `1` |  |
| signal.resources | object | `{}` |  |
| signal.securityContext | object | `{}` |  |
| signal.service.name | string | `"grpc"` |  |
| signal.service.port | int | `80` |  |
| signal.service.type | string | `"ClusterIP"` |  |
| signal.service.externalIPs | list | `[]` |  |
| signal.service.annotations | object | `{}` |  |
| signal.serviceAccount.annotations | object | `{}` |  |
| signal.serviceAccount.create | bool | `true` |  |
| signal.serviceAccount.name | string | `""` |  |
| signal.tolerations | list | `[]` |  |

For more configuration options, refer to the [values.yaml](./values.yaml) file.

You can find working [examples](./examples).

## STUN/TURN Server

If you need to deploy a High Available stun/turn server, please refer to this [blog](https://medium.com/l7mp-technologies/deploying-a-scalable-stun-service-in-kubernetes-c7b9726fa41d)

## Contributing

We welcome contributions to improve this chart! Please submit a pull request to the GitHub repository with any changes or suggestions.
