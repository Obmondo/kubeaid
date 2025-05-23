# Backup and Recovery

## Backup

Taking a backup of your data is very important since this is what gonna help you recover the data if data is lost

You can backup your data in S3 or Azure blob storage

The `spec.backup` section of the Cluster resource contains the parameters needed to configure backups.

CronJobs for postgresql logical backup cronjob template can be found [here](./examples/backup-template/postgresql-logical-backup.yaml).

### For S3

Here is a sample configuration for backing up data to S3-compatible storage:

```yaml
backup:
  retentionPolicy: "30d" # Archive retention period
  barmanObjectStore:
    destinationPath: "s3://grafana-backup/backups" # Path to the directory
    endpointURL: "https://s3.storage.foo.bar" # Endpoint of the S3 service
    s3Credentials: #  Credentials to access the bucket
      accessKeyId:
        name: s3-creds
        key: accessKeyId
      secretAccessKey:
        name: s3-creds
        key: secretAccessKey
    wal:
      compression: gzip # WAL compression is enabled
```

If you want to use `IAM` role then in the `spec` section you need to
add the `ServiceAccountTemplate` like -

```yaml
serviceAccountTemplate:
    metadata:
      annotations:
        eks.amazonaws.com/role-arn: arn:[...]
backup:
  retentionPolicy: "30d" # Archive retention period
  barmanObjectStore:
    destinationPath: "s3://grafana-backup/backups" # Path to the directory
    endpointURL: "https://s3.storage.foo.bar" # Endpoint of the S3 service
    wal:
      compression: gzip # WAL compression is enabled
```

### For Azure blob storage

```yaml
backup:
  retentionPolicy: "30d" # Archive retention period
  barmanObjectStore:
    destinationPath: "s3://grafana-backup/backups" # Path to the directory
    endpointURL: "https://s3.storage.foo.bar" # Endpoint of the S3 service
    azureCredentials:
        connectionString:
          name: azure-creds
          key: AZURE_CONNECTION_STRING
        storageAccount:
          name: azure-creds
          key: AZURE_STORAGE_ACCOUNT
        storageKey:
          name: azure-creds
          key: AZURE_STORAGE_KEY
        storageSasToken:
          name: azure-creds
          key: AZURE_STORAGE_SAS_TOKEN
    wal:
      compression: gzip # WAL compression is enabled
```

Note: -

CloudNativePG will save WAL files to the storage every 5 minutes once it is connected.
The Backup resource allows you to perform a full backup manually.
As the name suggests,the ScheduledBackup resource is for scheduled backups

```yaml
---
apiVersion: postgresql.cnpg.io/v1
kind: ScheduledBackup
metadata:
  name: grafana-pg-backup # Name of the backup
spec:
  immediate: true # Backup starts immediately after ScheduledBackup has been created
  schedule: "0 0 0 * * *"
  cluster:
    name: grafana-pg # Cluster name
```

## Recovery

Incase unthinkable happens and data is lost.Then don't worry
you can recover your data,there are two scenarios which you can look at

### Recovery from cluster backup

If your cluster still has the backup resource - then you can recover
that easily by adding the below in your cloudnative cluster resource `spec` section

```yaml
bootstrap:
    recovery:
      backup:
        name: $backup-name # backup is the name which you stated in scheduled backup above
```

### Recovery from S3 bucket or Azure blob storage

In case your entire cloudnativePG cluster resource is deleted
which means your in-cluster backup is also deleted - then don't
worry you can still recover your data from S3 bucket or Azure blob
storage given your backups are also happening there.
You can do that by adding the below in your cloudnative cluster resource `spec` section

Note: when you are creating a new cluster resource remember to change
the name of the cluster - since it can't be the same as of older one

#### From S3

```yaml
bootstrap:
    recovery:
      source: your-original-cluster-name
  externalClusters:
    - name: your-original-cluster-name
      barmanObjectStore:
        destinationPath: your s3 backup path
        endpointURL: your s3 endpoint
        s3Credentials:
          accessKeyId:
            name: backup-creds
            key: ACCESS_KEY_ID
          secretAccessKey:
            name: backup-creds
            key: ACCESS_SECRET_KEY
        wal:
          maxParallel: 8
```

#### From azure blob storage

```yaml
bootstrap:
    recovery:
      source: your-original-cluster-name
  externalClusters:
    - name: your-original-cluster-name
      barmanObjectStore:
      destinationPath: your s3 backup path
      endpointURL: your s3 endpoint
      azureCredentials:
        connectionString:
          name: azure-creds
          key: AZURE_CONNECTION_STRING
        storageAccount:
          name: azure-creds
          key: AZURE_STORAGE_ACCOUNT
        storageKey:
          name: azure-creds
          key: AZURE_STORAGE_KEY
        storageSasToken:
          name: azure-creds
          key: AZURE_STORAGE_SAS_TOKEN
        wal:
          maxParallel: 8
```

## Docs and External References

- https://www.enterprisedb.com/blog/current-state-major-postgresql-upgrades-cloudnativepg-kubernetes
