# Harbor

## Pushing images to Harbor

Go to the Harbor dashboard and log in. On the top-right side, your name will be present, clicking on which you would see the option to access user profile. On user profile, you can copy your CLI secret. This will act as your registry password. You can save this CLI secret in an environment variable and call it $REGISTRY_PASSWORD. 

Now you can login to the registry using buildah or docker. There is a demo below

buildah

```bash
echo $REGISTRY_PASSWORD | buildah login -u <username> --password-stdin <registry_url>
```

docker

```bash
docker login <registry_url>
```

You can build the container and push it using either docker or buildah using following commands

buildah

```bash
buildah bud -t "<registry_url>/<project_name>/<image_name>:<tag>" .
CONTAINER_ID=$(buildah from --pull=false "<registry_url>/<project_name>/<image_name>:<tag>") # not necessary
buildah commit --squash "$CONTAINER_ID" "<registry_url>/<project_name>/<image_name>:<tag>" # not necessary
buildah push "<registry_url>/<project_name>/<image_name>:<tag>"
```

docker

```bash
docker build -t "<registry_url>/<project_name>/<image_name>:<tag>" .
docker push "<registry_url>/<project_name>/<image_name>:<tag>"
```

## Giving Image Push Access

Harbor allows role based access management. To give an user some specific perms, you need to go to harbor, and in the Projects dashboard, go to the particular project name add user and select group that needs to be assigned to that particular user. Here is a link that elaborately explains what roles gives what permission to a particular user - https://goharbor.io/docs/2.1.0/administration/managing-users/user-permissions-by-role/

## Debugging Harbor OIDC Issues

Sometimes, when the changes related to your OIDC provider is done in Harbor, it starts throwing errors which goes like

```bash
failed to create user record: user Sanskar_Bhushan or email sanskar@obmondo.com already exists
```

To fix this issue you should log into the KBM cluster and run the following commands to find Harbor Postgres database

```bash
kubectl get all -n harbor
```

After running the above given command you should be able to see an output similiar to the one given below

```bash
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~$ kubectl get all -n harbor
NAME                                     READY   STATUS    RESTARTS      AGE
pod/harbor-core-5d584bc446-whw5w         1/1     Running   0             27m
pod/harbor-database-0                    1/1     Running   0             24h
pod/harbor-jobservice-5d64b4956f-h2pd4   1/1     Running   2 (46h ago)   46h
pod/harbor-portal-795cc5d55d-snh4d       1/1     Running   0             46h
pod/harbor-redis-0                       1/1     Running   0             46h
pod/harbor-registry-756bd69496-fxf9w     2/2     Running   0             46h
pod/harbor-trivy-0                       1/1     Running   0             46h

NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
service/harbor-core         ClusterIP   10.111.169.192   <none>        80/TCP              2d17h
service/harbor-database     ClusterIP   10.99.219.128    <none>        5432/TCP            5d19h
service/harbor-jobservice   ClusterIP   10.96.13.222     <none>        80/TCP              2d17h
service/harbor-portal       ClusterIP   10.104.115.157   <none>        80/TCP              2d17h
service/harbor-redis        ClusterIP   10.105.81.73     <none>        6379/TCP            2d17h
service/harbor-registry     ClusterIP   10.103.190.151   <none>        5000/TCP,8080/TCP   2d17h
service/harbor-trivy        ClusterIP   10.96.165.179    <none>        8080/TCP            2d17h

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/harbor-core         1/1     1            1           46h
deployment.apps/harbor-jobservice   1/1     1            1           46h
deployment.apps/harbor-portal       1/1     1            1           46h
deployment.apps/harbor-registry     1/1     1            1           46h

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/harbor-core-5d584bc446         1         1         1       46h
replicaset.apps/harbor-jobservice-5d64b4956f   1         1         1       46h
replicaset.apps/harbor-portal-795cc5d55d       1         1         1       46h
replicaset.apps/harbor-registry-756bd69496     1         1         1       46h

NAME                               READY   AGE
statefulset.apps/harbor-database   1/1     24h
statefulset.apps/harbor-redis      1/1     46h
statefulset.apps/harbor-trivy      1/1     46h
```

Now we need to get inside the pod corresponding to the 'harbor-database' stateful set using the following command

```bash
kubectl exec -it pod/harbor-database-0 -n harbor -- /bin/bash
```

After getting inside the pod, you would be able to access the Postgres container, and thus would be able to perform operations manually on the database. In order to access the database corresponding to the Harbor registry, run the command

```bash
psql -U postgres -d registry
```

In order to get get the user record, run the command

```sql
select * from harbor_user;
```

### Accessing Harbor admin dashboard

In order to access Harbor admin dashboard we first need to reset the existing Harbor password from inside the database usign the following command

```sql
update harbor_user set salt='', password='' where user_id = 1;
```

This will reset the Harbor admin credential to its initial form. Now exit the database and the Postgres pod using the commands

```bash
\q
exit
```

Restart the Harbor core pod by deleting the pod using the command given below and replicaset will take care of restarting the pod again

```bash
kubectl delete pod -n harbor -l component=core
```

Once the pod is restarted then enter inside the restarted pod using the following command

```bash
kubectl exec -it pod/harbor-core-5d584bc446-whw5w -n harbor -- /bin/bash
```

After getting inside the pod, access the admin credentials using the following command

```bash
env | grep -i admin
```

Use the username 'admin' and the found out credential to log into the Harbor as an admin and then you can manually delete the older users from there which will fix the persisting issue.

### Deleting existing users directly via database

After running this command you would be able to get a list of all the Harbor users. Now in order to fix the persisting issue, you simply delete all the older users and this issue will be fixed. Before manually performing any operations on Database, always consult your senior as it may have unwanted consequences and you might lose your data.

## Debugging Harbor State Mismatch Issues

This issue generally persists because of bad caches that leads to troubles. In order to fix this issue you simply need to delete all the existing Harbor deployment and statefulsets and resync them using Argo CD that will lead to a complete clean-up of all the previous session cache and will help you get rid of this issue.

## Clean Up of Harbour

When you delete images from Harbor, the space isn't automatically reclaimed. To free up space, you need to perform garbage collection, which removes unreferenced blobs from the file system.

**Note**: You need admin privileges for running Garbage Collection. 

### Running Garbage Collection

1. **Log** in: Access the Harbor interface with a system administrator account.
2. **Navigate**: Go to `Administration` > `Garbage Collection` > `Garbage Collection` tab.
3. **Options**:
   - To remove untagged artifacts, check the `Delete Untagged Artifacts` box.
   - To start garbage collection, click `GC Now`.

**Note**: During garbage collection, Harbor enters read-only mode, preventing any modifications to the registry. The `GC Now` button is limited to being used once per minute to prevent frequent triggering.

### Scheduling Garbage Collection

1. **Navigate**: Go to `Administration` > `Garbage Collection` > `Garbage Collection` tab.
2. **Schedule**: Click Edit and choose the frequency from the drop-down menu:
    - `None`: No scheduled garbage collection.
    - `Hourly`: Every hour at the beginning.
    - `Daily`: Every day at midnight.
    - `Weekly`: Every Saturday at midnight.
    - `Custom`: Set a custom schedule using a cron job.
3. **Options**: To remove untagged artifacts, check the Delete Untagged Artifacts box.
4. **Save**: Click `Save`.

### Viewing Garbage Collection History

1. **History**: Go to the `History` tab to see the records of the 10 most recent garbage collection runs.
2. **Logs**: Click the icon in the `Logs` column to view the logs for a specific garbage collection job.

### Log Deletion

1. **Log Retention**: By default, Harbor retains garbage collection logs. However, you may need to delete old logs to free up space.
2. **Navigate**: Go to `Administration` > `Garbage Collection` > `History` tab.
3. **Delete Logs**: Select the logs you wish to delete and click the `Delete` button.
4. **Confirm**: Confirm the deletion to remove the selected logs from the system.

By managing garbage collection and log deletion, you can maintain optimal storage space and system performance in Harbor.

For more Detailed information you can also checkout - [Harbor Doc](https://goharbor.io/docs/2.0.0/administration/garbage-collection/)
