# Teleport Cluster

## Upgrade

* Check pv is set to `Retain`
* Backup data by taking a shell on the teleport-cluster pod

  ```sh
  tctl get all --with-secrets > state.yaml
  ```

* Copy the backup to local laptop/desktop

  ```sh
  kubectl cp teleport-cluster/teleport-cluster-7dcbdbfc7d-drhg4:/backup.yaml .
  ```
