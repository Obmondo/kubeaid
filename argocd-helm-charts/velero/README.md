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

## Create SealedSecret for Velero using file

```sh
kubectl create secret generic cloud-credentials -n velero  --from-file=cloud=cloud-credentials.yaml -o yaml --dry-run=client | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml > cloud.yaml
```

Where, contents of file `cloud-credentials.yaml` is shown below. From cloud to cloud the variable
differs. And NOTE that this is only valid for Azure cloud.

```text
AZURE_SUBSCRIPTION_ID=fkfkfdfdfdkfjlss
AZURE_TENANT_ID=wellllcmdndkdkd
AZURE_CLIENT_ID=3920keeiwid93ri3jm3idn3din3
AZURE_CLIENT_SECRET=ekji2ieje8eje3ij3i
AZURE_RESOURCE_GROUP=MC_k8s-prod-ddkkwji
AZURE_CLOUD_NAME=AwsPublicCloud
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

## Create Token

Generating a azure token with role as contributor, scope as a subscription id for lifelong.

```sh
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription-id>" --years 4000 --output json
```

## References

* [How Velero Works](https://velero.io/docs/v1.9/how-velero-works/)
* [Velero Troubleshooting Guide](https://velero.io/docs/v1.3.2/troubleshooting/)
* [Azure Resource not found](https://velero.io/docs/v1.3.2/troubleshooting/)
