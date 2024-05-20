# rook-ceph

## Debugging: See Ceph status

To see rook-ceph status look at the live manifest for the kubernetes resource CephCluster/rook-ceph
under "status:" it should say "HEALTH_OK" or there is something wrong.
To see exactly what is wrong first look at pods with `kubectl -n rook-ceph get pods`
If all pods are OK, then look in ceph-tools with

```shell
    kubectl -n rook-ceph exec -it rook-ceph-tools-<pod-name> -- bash
    # This would give the status of the cluster
    ceph status
```

If that doesnt work you can use the rook-ceph kubectl plugin
`kubectl rook-ceph ceph status`

- Look into alert handling for [CephOSDDiskUnavailable.md](https://gitlab.enableit.dk/obmondo/wiki/-/blobrook-ceph/procedures/alerts/CephOSDDiskUnavailable.md)
    for more debug information.

## About upstream charts

This includes both of the two upstream rook-ceph charts listed here
`https://rook.io/docs/rook/v1.10/Helm-Charts/helm-charts/`

The upstream chart called "rook-ceph" contains the CRDs and operator (rook)
which watches for Ceph CRs
The upstream chart called "rook-ceph-cluster" contains the Ceph CRs
that make rook setup Ceph on a cluster
