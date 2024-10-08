# External Snapshotter

External snapshotter is used to create Volume Snapshots of the Persistent Volumes.

## Documentation

- https://github.com/kubernetes-csi/external-snapshotter#readme
- https://kubernetes.io/blog/2020/12/10/kubernetes-1.20-volume-snapshot-moves-to-ga/
- https://kubernetes.io/docs/concepts/storage/volume-snapshots/

## Troubleshooting

Sometimes, VolumeSnapshots remain on the cluster long after a backup from Velero or a similar
application has been deleted. We need to check the snapshots on our cloud provider periodically
to avoid spending on cloud costs for unused snapshots. Check more details on the
[Velero Helm chart readme](https://gitlab.enableit.dk/kubernetes/kubeaid/-/blob/master/argocd-helm-charts/velero/README.md#troubleshooting)
