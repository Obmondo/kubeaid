# copy-snapshot
The copy-snapshot system is created to improve the resilience of our backup system, by copying the snapshots to another AWS region.

The system is implemented using k8s CronJob. The system works by:

- Parsing the data files, that Velero stores in S3, to identify the snapshots, related to the specified backup schedule.
- Identify all snapshots stored in the destination region.
- Copy all snapshots, which are not already present at the destination region.
- Delete any snapshots from the destination region, when they are too old.

There is not any kind of database, identifying the snapshots at the destination region. All the information is stored, using tags on the the snapshots.


# Restoring

To help restore from the copied snapshots, two commands have been created: “list-replicated-snapshots” and “restore”. They are located in the “argocd-helm-charts/copy-snapshot/restore” directory in the “k8s-init” repository.

## list-replicated-snapshots
This command will show a list of all the copied snapshots, using information extracted from the tags on the snapshots.

## Restore
This command, will help restore a copied snapshot, to a Kubernetes volume. The process works like this:

- Execute the restore script, like this: “./restore &lt;backup name&gt; &lt;PVC name&gt;”
- The snapshot will be copied back to the eu-west-1 region
- A new EBS volume will be created, based on the new snapshot.
- A new PersistentVolume will be created in the current Kubernetes cluster, using the recently created EBS volume.
- A proposed PVC object definition will be created, and stored in a file called “pvc.yaml”.

### Replace an existing PVC
To finish the restore process, a PVC will need to be created in Kubernetes. To replace an existing PVC, the old PVC needs to be unmounted. This can be done like this:

- Stop the Pod, that is using the PVC.
- Delete the PVC: “kubectl delete PVC &lt;PVC name&gt;”
- Wait a bit, and verify that the PVC is actually removed from the cluster: “kubectl get PVC &lt;PVC name&gt;”
- Created a new PVC, using the “pvc.yaml” file: “kubectl create -f pvc.yaml”
- Restart the Pod.

### Restore to a new PVC
To restore the PVC, to a new PVC:

- Edit pvc.yaml, changing the name and/or namespace.
- Created a new PVC, using the “pvc.yaml” file: “kubectl create -f pvc.yaml”

