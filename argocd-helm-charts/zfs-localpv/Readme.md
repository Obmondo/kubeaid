# zfs-localpv chart setup

Prerequisites:

1. zfs pool is created on k8s nodes where required.
2. Node are correctly labelled, with zfs label (if you wish to run zfs-controller and zfs-node on certain k8s nodes)

## Create a zfs pool

To check available drives
`sudo fdisk -l`
Creating a mirrored zpool
`sudo zpool create -m /mnt/nvmelocal mypool mirror /dev/sdb /dev/sdc`
> Assuming `/dev/sdb` and `/dev/sdc` are the disks you want to have your mirrored pool on,
> and `nvmelocal` is name of storage pool. Which is mounted at `/mnt/nvmelocal`.

## Label nodes

To label nodes, get all modes in a cluster:
`kubectl get nodes`

To label a specific node:
`kubectl label node <node_name> filesystem=zfs`

To check if nodes are labelled:
`kubectl get node <node_name> --show-labels`

## Node-selector

Now to run zfs-controller and zfs-node on specific k8s node, use nodeselector field in values file available
see values in [examples/](https://gitlab.enableit.dk/kubernetes/k8id/-/blob/master/argocd-helm-charts/zfs-localpv/examples/values-nodeselector.yaml).

## Storageclass

Now, once the chart is deployed with custom values next step would be to create a storageclass in order to use the zfs storage.
See [examples/](https://gitlab.enableit.dk/kubernetes/k8id/-/blob/master/argocd-helm-charts/zfs-localpv/examples/storageclass.yaml)

For more details on available parameters for zfs-localpv. Check this [doc](https://github.com/openebs/zfs-localpv/blob/develop/docs/storageclasses.md).

Once, storageclass is deployed. You can check it by running this command inside the cluster `kubectl get sc`

> Note:
> The zfs-localpv does not by default ship with `storageclass` parameter
> in `values.yaml`. We have added this parameter(by default false):

```yaml

storageClass:
  enabled: true
  poolName: mypool
  reclaimPolicy: {}

```

> if enabled in `values.yaml` will apply this [manifest](https://gitlab.enableit.dk/kubernetes/k8id/-/blob/master/argocd-helm-charts/zfs-localpv/templates/storageclass.yaml).
