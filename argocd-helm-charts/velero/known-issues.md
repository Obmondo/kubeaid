# Known Issues for alerts

## VeleroUnsuccessfulBackup

### Logs

```sh
NAME                                   STATUS            ERRORS   WARNINGS   CREATED                         EXPIRES   STORAGE LOCATION   SELECTOR
backup-1                               Completed         0        2          2024-03-08 13:40:48 +0530 IST   18d       default            <none>
staging-6hrly-backup-20240319060020    PartiallyFailed   18       2          2024-03-19 11:30:20 +0530 IST   13d       default            <none>
staging-6hrly-backup-20240318180019    PartiallyFailed   21       2          2024-03-18 23:30:19 +0530 IST   13d       default            <none>
staging-6hrly-backup-20240318120019    PartiallyFailed   14       2          2024-03-18 17:30:19 +0530 IST   13d       default            <none>
staging-6hrly-backup-20240318060018    PartiallyFailed   18       2          2024-03-18 11:30:18 +0530 IST   12d       default            <none>
staging-6hrly-backup-20240317180017    PartiallyFailed   21       2          2024-03-17 23:30:17 +0530 IST   12d       default            <none>
staging-6hrly-backup-20240317120017    PartiallyFailed   17       2          2024-03-17 17:30:17 +0530 IST   12d       default            <none>
staging-6hrly-backup-20240317060017    PartiallyFailed   19       2          2024-03-17 11:30:17 +0530 IST   11d       default            <none>
staging-6hrly-backup-20240316180016    PartiallyFailed   17       2          2024-03-16 23:30:16 +0530 IST   11d       default            <none>
```

```sh
time="2024-03-19T06:04:56Z" level=error msg="Error backing up item" backup=velero/staging-6hrly-backup-20240319060020 error="error executing custom action (groupResource=volumesnapshots.snapshot.storage.k8s.io, namespace=socket, name=velero-redis-data-socket-api-redis-replicas-0-w9bvn): rpc error: code = Unknown desc = error getting volume snapshot content from API: volumesnapshotcontents.snapshot.storage.k8s.io \"snapcontent-098f49a8-ecda-435b-aad9-7e71f8006036\" not found" error.file="/go/src/github.com/vmware-tanzu/velero/pkg/backup/item_backupper.go:366" error.function="github.com/vmware-tanzu/velero/pkg/backup.(*itemBackupper).executeActions" logSource="pkg/backup/backup.go:448" name=velero-redis-data-socket-api-redis-replicas-0-w9bvn
```

This alert is thrown when velero backups are giving `PartiallyFailed` status. However, the above error messages doesn't
indicate a failed backup. In this case we are getting partially failed because velero is trying to backup volume snapshot
content that does not exist which is resulting in a not found error. There is already an
[upstream ticket](https://github.com/vmware-tanzu/velero/issues/5781) for the same.

[One of the fixes](https://gitea.obmondo.com/EnableIT/KubeAid/pulls/161/files) that was tried was to add the label
`velero.io/exclude-from-backup: "true"`to the resources that were to be ignored by velero for backup. There was
[another upstream issue](https://github.com/vmware-tanzu/velero/issues/5507) noticed because of this where the resources
with the label were ignored during backup triggered manually, but the PartiallyFailed status still occurs during
scheduled backups.
