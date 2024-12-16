# snapshot-controller

Deploys the [snapshot-controller](https://github.com/kubernetes-csi/external-snapshotter) in a cluster.
The controller is required for CSI snapshotting to work and is not specific to any CSI driver.

While many Kubernetes distributions already package this controller, some do not. If your cluster does ***NOT***
have the following CRDs, you likely also do not have a snapshot controller deployed:

```
kubectl get crd volumesnapshotclasses.snapshot.storage.k8s.io
kubectl get crd volumesnapshots.snapshot.storage.k8s.io
kubectl get crd volumesnapshotcontents.snapshot.storage.k8s.io
```

## Usage

See [below](#configuration) for available configuration options.

```
helm repo add piraeus-charts https://piraeus.io/helm-charts/
helm install snapshot-controller piraeus-charts/snapshot-controller
```

## Upgrades

Upgrades can be done using the normal Helm upgrade mechanism

```
helm repo update
helm upgrade snapshot-controller piraeus-charts/snapshot-controller
```

To enjoy all the latest features of the snapshot controller, you may want to upgrade your CRDs as well:

```
kubectl replace -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.2.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl replace -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.2.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl replace -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.2.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
```

## Upgrade from older CRDs

In an effort to tighten validation, the CSI project started enforcing stricter requirements on `VolumeSnapshot` and
`VolumeSnapshotContent` resources when switching from `v1beta1` to `v1` CRDs. This validation webhook is part of
enforcing these requirements. When upgrading you [have to ensure non of your resources violate the requirements for `v1`].

The upgrade procedure can be summarized by the following steps:

1. Remove the old snapshot controller, if any (since you are upgrading, you probably already have one deployed manually).
2. Install the snapshot controller and the validation webhook using one of the [`3.x.x` releases]:

   ```
   helm install piraeus-charts/snapshot-controller --set controller.image.tag=v3.0.3 --set webhook.image.tag=v3.0.3
   ```
3. Ensure that none of the resources are labelled as invalid:

   ```
   kubectl get volumesnapshots --selector=snapshot.storage.kubernetes.io/invalid-snapshot-resource="" --all-namespaces
   kubectl get volumesnapshotcontents --selector=snapshot.storage.kubernetes.io/invalid-snapshot-resource="" --all-namespaces
   ```

   If the above commands output any resource, they have to be removed

4. Upgrade the CRDs

   ```
   kubectl replace -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v5.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
   kubectl replace -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v5.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
   kubectl replace -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v5.0.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
   ```

5. Upgrade to the latest version:

   ```
   helm upgrade piraeus-charts/snapshot-controller --set controller.image.tag=v5.0.0 --set webhook.image.tag=v5.0.0
   ```

## Configuration

### Snapshot controller
The following options are available:

| Option                                   | Usage                                                                                                                  | Default                                                                                            |
|------------------------------------------|------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| `controller.enabled`                     | Toggle to disable the deployment of the snapshot controller.                                                           | `true`                                                                                             |
| `controller.fullnameOverride`            | Set the base name of deployed resources. Defaults to `snapshot-controller`.                                            | `""`                                                                                               |
| `controller.args`                        | Arguments to pass to the snapshot controller. Note: Keys will be converted to kebab-case, i.e. `oneArg` -> `--one-arg` | `...`                                                                                              |
| `controller.replicaCount`                | Number of replicas to deploy.                                                                                          | `1`                                                                                                |
| `controller.revisionHistoryLimit`        | Number of revisions to keep.                                                                                           | `10`                                                                                               |
| `controller.image.repository`            | Repository to pull the image from.                                                                                     | `registry.k8s.io/sig-storage/snapshot-controller`                                                  |
| `controller.image.pullPolicy`            | Pull policy to use. Possible values: `IfNotPresent`, `Always`, `Never`                                                 | `IfNotPresent`                                                                                     |
| `controller.image.tag`                   | Override the tag to pull. If not given, defaults to charts `AppVersion`.                                               | `""`                                                                                               |
| `controller.imagePullSecrets`            | Image pull secrets to add to the deployment.                                                                           | `[]`                                                                                               |
| `controller.podAnnotations`              | Annotations to add to every pod in the deployment.                                                                     | `{}`                                                                                               |
| `controller.podLabels`                   | Labels to add to every pod in the deployment.                                                                          | `{}`                                                                                               |
| `controller.podSecurityContext`          | Security context to set on the webhook pod.                                                                            | `{}`                                                                                               |
| `controller.priorityClassName`           | Priority Class to set on the deployment pods.                                                                          | `""`                                                                                               |
| `controller.securityContext`             | Configure container security context. Defaults to dropping all capabilties and running as user 1000.                   | `{capabilities: {drop: [ALL]}, readOnlyRootFilesystem: true, runAsNonRoot: true, runAsUser: 1000}` |
| `controller.resources`                   | Resources to request and limit on the pod.                                                                             | `{}`                                                                                               |
| `controller.nodeSelector`                | Node selector to add to each webhook pod.                                                                              | `{}`                                                                                               |
| `controller.tolerations`                 | Tolerations to add to each webhook pod.                                                                                | `[]`                                                                                               |
| `controller.topologySpreadConstraints`   | Topology spread constraints to set on each pod.                                                                        | `[]`                                                                                               |
| `controller.affinity`                    | Affinity to set on each webhook pod.                                                                                   | `{}`                                                                                               |
| `controller.pdb`                         | PodDisruptionBudget to set on the webhook pod.                                                                         | `{}`                                                                                               |
| `controller.rbac.create`                 | Create the necessary roles and bindings for the snapshot controller.                                                   | `true`                                                                                             |
| `controller.serviceAccount.create`       | Create the service account resource                                                                                    | `true`                                                                                             |
| `controller.serviceAccount.name`         | Sets the name of the service account. If left empty, will use the release name as default                              | `""`                                                                                               |
| `controller.hostNetwork`                 | Change `hostNetwork` to `true` when you want the pod to share its host's network namespace.                            | `false`                                                                                            |
| `controller.dnsConfig`                   | DNS settings for controller pod.                                                                                       | `{}`                                                                                               |
| `controller.dnsPolicy`                   | DNS Policy for controller pod. For Pods running with hostNetwork, set to `ClusterFirstWithHostNet`.                    | `ClusterFirst`                                                                                     |

[`3.x.x` releases]: https://github.com/kubernetes-csi/external-snapshotter/releases
[have to ensure non of your resources violate the requirements for `v1`]: https://github.com/kubernetes-csi/external-snapshotter#validating-webhook

