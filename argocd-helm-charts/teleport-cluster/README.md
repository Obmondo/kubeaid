# Teleport Cluster

## Upgrade

* Check pv is set to `Retain`
* Backup and keep the copy locally incase of recovery

  ```sh
  tctl get all --with-secrets > state.yaml
  ```
