# Velero

## How to check the backup in Velero

```sh
kubectl get backup -n velero
```

## Docs

* https://github.com/vmware-tanzu/helm-charts/blob/main/charts/velero/README.md

## Issues

Velero keeps a track of schedules even when they are deleted.
https://github.com/vmware-tanzu/velero/issues/1333

It keeps publishing the metrics of older schedules even after removing them.
The available solution for now is to kill the pods when no backups/restores are being performed.

## Troubleshooting

Install the Velero CLI.
Use this command to describe and check logs of a particular backup.

```sh
# Get info about a backup
velero backup describe <backup_name>

# Get logs about a backup
velero backup logs <backup_name>
```

## Create SealedSecret for Velero

Depending on the cloud provider, run the script located inside `/bin/<cloud>` directory. (Currently only `Azure` is supported)

```sh
# help
./azure --help

# running the script
./azure --client-secret xxxx --cluster-name cluster.company.com
```

Script will generate `credentials-velero.json` in same directory. User has to apply that file to the desired cluster.

## References

* [How Velero Works](https://velero.io/docs/v1.9/how-velero-works/)
* [Velero Troubleshooting Guide](https://velero.io/docs/v1.3.2/troubleshooting/)
* [Azure Resource not found](https://velero.io/docs/v1.3.2/troubleshooting/)
