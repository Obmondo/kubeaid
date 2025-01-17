
# Migrate mattermost-team-edition to k8S

## Upgrading Mattermost on Kubernetes

- check mattermost helm chart on kubeaid and compare it with upstream (raise PR if diff)
- trigger a manual cronjob via k9s (with `t` keystroke)
- pg_dump -d mattermost | gzip  > /tmp/mattermost-db.sql.gz (take a manual one, so it easier to recover
against taking from s3)
- kubectl cp mattermost/mattermost-pgsql-0:/tmp/mattermost-db.sql.gz ./mattermost_dbdump_2024-02-13.sql.gz
- take the PV backups by following the guide 'Taking Mattermost PV backups' down below.
- edit the deployment via k9s and set replicas to 0
- refresh the mattermost app on argocd and see the diff (if all good, sync it)
- look for events and description of the pod

NOTE: only mattermost pod should be touched, nothing else and that too via the means of downscaling it
using deployment as mentioned in point '6'.

## Updating upstream chart

Update it the regular way then reapply git patch from the MR that adds support for plugins with their own webservers.
If upstream changes have changed something that breaks that patch, then fix it.

## Follow to Enable Keycloak SSO (OAuth) for Mattermost Teams Edition

## Configure Mattermost config values**

- From Mattermost v7.5, environment configuration parsing supports JSON for `MM_PLUGINSETTINGS_PLUGINSTATES`
    and `MM_PLUGINSETTINGS_PLUGINSTATES`.

- For `MM_PLUGINSETTINGS_PLUGINSTATES` and `MM_PLUGINSETTINGS_PLUGINS` write a simple json following this format
    [config.json](https://github.com/mattermost/mattermost-server/blob/master/tests/test-config.json#L379) and escape
        the json strings. This website can be used to escape json easily refer [codebeauty.org](https://codebeautify.org/json-escape-unescape).

```text
MM_GITLABSETTINGS_ENABLE: "true"
MM_GITLABSETTINGS_USERAPIENDPOINT: "https://<keycloak-domain>/auth/realms/<realm-name>/protocol/openid-connect/userinfo"
MM_GITLABSETTINGS_AUTHENDPOINT: "https://<keycloak-domain>/auth/realms/<realm-name>/protocol/openid-connect/auth"
MM_GITLABSETTINGS_TOKENENDPOINT: "https://<keycloak-domain>/auth/realms/<realm-name>/protocol/openid-connect/token"
MM_PLUGINSETTINGS_PLUGINSTATES: "{\n\"com.github.matterpoll.matterpoll\":{\n\"Enable\":true\n}\n}"
```

**Create Client on Keycloak**
In keycloak go to Configure > Clients and create a new client for
Mattermost With the following data:

```text
Standard Flow Enabled: ON
Access Type: confidential
Valid Redirect URIs: http://<Mattermost-domain>/signup/gitlab/complete
```

**Create mapper for correct data**
Mattermost want the following data from the authentication provider:

```golang
type GitLabUser struct {
 Id       int64  `json:"id"`
 Username string `json:"username"`
 Login    string `json:"login"`
 Email    string `json:"email"`
 Name     string `json:"name"`
}

```

### Create mapping for username, id, login, email, name

```text
Make sure to map the correct id under user -> attributes -> "mattermostid" = <user-id-from-gitlab>
```

## Note

```text
New user without mattermostid attribute in keycloak wont work
```

For more info refer to - <https://devopstales.github.io/sso/mattermost-keycloak-sso>

## Follow to migrate existing mattermost data to k8S  

1. Backup existing mattermost Database by running the following command.

    ```shell
    sudo -i -u gitlab-psql -- /opt/gitlab/embedded/bin/pg_dump -h /var/opt/gitlab/postgresql mattermost_production |
    gzip > mattermost_dbdump_$(date --rfc-3339=date).sql.gz
    ```

2. Back up the data directory and config.json.

    ```shell
    sudo tar -zcvf mattermost_data_$(date --rfc-3339=date).gz -C /var/opt/gitlab/mattermost data config.json
    ```

3. Stop mattermost pod in the k8s to have sync issue.

    ```text
    Delete the mattermost-team-edition-... pod from argo cd UI.
    ```

4. Assuming we downloaded the backup files from backup from step 1. & 2. .

    ```text
    Example - mattermost_data_2022-08-02.gz  mattermost_dbdump_2022-08-02.sql.gz
    ```

5. Copy and extract the DB dump which was backed up in step 1. from local machine to the postgresql pod by runinng the command.

    ```shell
    kubectl cp mattermost_dbdump_2022-08-02.sql.gz mattermost/mattermost-pgsql-0:/tmp
    kubectl exec -it mattermost-pgsql-0 sh -n mattermost
    cd /tmp
    gzip -d mattermost_dbdump_2022-08-02.sql.gz
    ```

6. Get the postresql DB password for appending the sql file to the new DB.

    ```shell
    kubectl get secret postgres.mattermost-pgsql.credentials.postgresql.acid.zalan.do -n mattermost -o jsonpath='{.data.password}' | base64 --decode

    ```

7. Run the command to copy files to the DB.

    ```shell
    psql -h 127.0.0.1 -p 5432 -d mattermost -U postgres < mattermost_dbdump_2022-08-02.sql
    ```

8. Now start the mattermost-team-edition from the Argo-cd UI by sync the deployment.

    ```text
    Press the sync button on the UI
    ```

9. Copy the mattermost_data_2022-08-02.gz to mattermost pod and extact it.

    ```shell
    kubectl cp mattermost_data_2022-08-02.gz mattermost/mattermost-team-edition-...:/tmp
    kubectl exec -it mattermost-team-edition-.. sh -n mattermost
    cd /tmp
    mv mattermost_data_2022-08-02.gz mattermost_data_2022-08-02.tar
    tar -xvf mattermost_data_2022-08-02.tar -C /mattermost/
    ```

10. If all goes well now we have to restart the mattermost-team-edition pod from the argo CD ui to sync the
    mattermost-team-edition with the changes.

### Moving mattermost to a new cluster

1. Backup existing mattermost Database by running the following command on the old cluster's postgres pod.

    ```shell
    pg_dump -c -U mattermost | gzip > mattermost_dbdump_$(date --rfc-3339=date).sql.gz
    
   # Copy the data to local machine
    kubectl cp mattermost/mattermost-pgsql-0:/mattermost_dbdump_....gz .
    ```

2. Backup the data directory .

    ```shell
    sudo tar -zcvf mattermost_data_$(date --rfc-3339=date).gz data

    # Copy the data to local machine
    kubectl cp mattermost/mattermost-team-edition-...:/mattermost_data_2022-08-02.gz .
    ```

3. Delete the postgres and mattermost deployment from the new cluster via argocd and sync only the
    postgres deployment so we don't have any old tables.

4. Copy the databse backup file to the new cluster's postgres pod and append the sql files to database.

    ```shell
    kubectl cp mattermost_dbdump_2022-08-02.sql.gz mattermost/mattermost-pgsql-0:/tmp
    kubectl exec -it mattermost-pgsql-0 sh -n mattermost
    cd /tmp
    gzip -d mattermost_dbdump_2022-08-02.sql.gz

    # Get the password for the postgresql DB
    kubectl get secret postgres.mattermost-pgsql.credentials.postgresql.acid.zalan.do -n mattermost -o jsonpath='{.data.password}' | base64 --decode

    # Run the command to copy files to the DB.
    psql -h 127.0.0.1 -p 5432 -d mattermost -U postgres < mattermost_dbdump_2022-08-02.sql
    ```

5. Sync the mattermost deployment from the argocd UI, that will create mattermost pod and copy the data to
    the mattermost pod and sync it.

    ```shell
    kubectl cp mattermost_data_....gz mattermost/mattermost-team-edition-...:/tmp
    tar -xvf mattermost_data_....tar -C /mattermost/
    ```

### Issues that might occur during upgrade

1. DB lock issue

    ```text
    If you get the following error after syncing the changes for new version of mattermost.

    psql: cannot acquire lock on db
    ```

    ```text
    Solution - Delete the old mattermost-team-edition deployment resource from the argocd UI .
    ```

### Taking Mattermost PV backups

- It must be kept in mind that Velero must be running in the cluster where you intend to take
volumesnapshots, you can check it using the command

```sh
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~$ kubectl get all -n velero
NAME                          READY   STATUS    RESTARTS   AGE
pod/velero-6d4c7f5448-sdpxz   1/1     Running   0          15d

NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/velero   ClusterIP   10.110.241.242   <none>        8085/TCP   96d

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/velero   1/1     1            1           96d
```

- Now take a look at the PVCs present in the 'mattermost' namespace using the command

```sh
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~/Videos/Personal Stuff$ kubectl get pvc -n mattermost
NAME                              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS
AGE
mattermost-team-edition           Bound    pvc-0cb29fa5-83b5-4cfa-a918-25097b52a72b   10Gi       RWO            rook-ceph-block
6d21h
mattermost-team-edition-plugins   Bound    pvc-b43a5e89-77c9-468a-aca7-ed08d3d756f2   1Gi        RWO            rook-ceph-block
6d21h
pgdata-mattermost-pgsql-0         Bound    pvc-82603507-4970-4591-ba77-8f480361d280   32Gi       RWO            rook-ceph-block
6d21h
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~/Videos/Personal Stuff$
```

- Now we need to take the snapshots of all these PVCs and the PVs that back them in order to be
safe. In order to do so we need to have a volumesnapshotclass in our cluster. Let's check if we
have one or not using the following command

```sh
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~/Videos/Personal Stuff$ kubectl get volumesnapshotclass
NAME              DRIVER                       DELETIONPOLICY   AGE
velero-snapshot   rook-ceph.rbd.csi.ceph.com   Retain           44d
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~/Videos/Personal Stuff$
```

- As we have checked if we have volumesnapshotclass or not, we can proceed with the next step i.e.
to create volumesnapshot, so for all the PVCs in 'mattermost' namespace we can have the following
manifests to create volumesnapshot

```sh
snapshot-pgsql.yaml ---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: snapshot-pgsql
spec:
  volumeSnapshotClassName: velero-snapshot
  source:
    persistentVolumeClaimName: pgdata-mattermost-pgsql-0
```

```sh
snapshot-team-edition-plugins.yaml ---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: snapshot-team-edition-plugins
spec:
  volumeSnapshotClassName: velero-snapshot
  source:
    persistentVolumeClaimName: mattermost-team-edition-plugins
```

```sh
snapshot-team-edition.yaml ---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: snapshot-team-edition
spec:
  volumeSnapshotClassName: velero-snapshot
  source:
    persistentVolumeClaimName: mattermost-team-edition
```

We need to apply these volumesnapshots in 'mattermost' namespace and that will do
the job for us

- Just validate the snapshots creations using the command and Voila!

```sh
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~/Videos/Personal Stuff$ kubectl get volumesnapshot -n mattermost
NAME                                           READYTOUSE   SOURCEPVC                         SOURCESNAPSHOTCONTENT
RESTORESIZE   SNAPSHOTCLASS     SNAPSHOTCONTENT                                    CREATIONTIME   AGE
snapshot-pgsql                                 true         pgdata-mattermost-pgsql-0
32Gi          velero-snapshot   snapcontent-46e9e97d-07d3-4102-b643-9571cdf66ae1   38s            40s
snapshot-team-edition                          true         mattermost-team-edition
10Gi          velero-snapshot   snapcontent-a822c014-d5bf-414a-93b3-942c62475c1c   18s            20s
snapshot-team-edition-plugins                  true         mattermost-team-edition-plugins
1Gi           velero-snapshot   snapcontent-c50154d7-ebd8-4afb-b937-e061bcaba3c2   28s            30s
velero-mattermost-team-edition-d4l78           true         mattermost-team-edition
10Gi          velero-snapshot   snapcontent-337ae4b4-f01e-4504-ba9e-dcf1e3561bee   27d            27d
velero-mattermost-team-edition-hmqd7           true         mattermost-team-edition
10Gi          velero-snapshot   snapcontent-98d15eb1-a05b-4d6a-ab4d-c5bfcf5d3ac6   28d            28d
velero-mattermost-team-edition-k52mt           true         mattermost-team-edition
10Gi          velero-snapshot   snapcontent-463781fc-97de-400a-bfc5-3002933bff90   27d            27d
velero-mattermost-team-edition-plugins-blqrp   true         mattermost-team-edition-plugins
1Gi           velero-snapshot   snapcontent-bdb4b3b5-0333-4c67-a4bb-288055b4f116   27d            27d
velero-mattermost-team-edition-plugins-lmqdw   true         mattermost-team-edition-plugins
1Gi           velero-snapshot   snapcontent-529850de-5a75-424d-ac88-876ef8078aa4   28d            28d
velero-mattermost-team-edition-plugins-qbztm   true         mattermost-team-edition-plugins
1Gi           velero-snapshot   snapcontent-4d414dff-37c7-4f0d-9d24-81fad3b65c97   27d            27d
velero-pgdata-mattermost-pgsql-0-62dlx         true         pgdata-mattermost-pgsql-0
32Gi          velero-snapshot   snapcontent-d21f6195-ab8e-4d17-bc17-c770d15b44d3   27d            27d
velero-pgdata-mattermost-pgsql-0-8d8gv         true         pgdata-mattermost-pgsql-0
32Gi          velero-snapshot   snapcontent-95658f5d-14ab-48d2-a151-d7b321be318c   28d            28d
velero-pgdata-mattermost-pgsql-0-lzzqs         true         pgdata-mattermost-pgsql-0
32Gi          velero-snapshot   snapcontent-4f967d06-d9ce-4052-bd51-f2bd717cad01   27d            27d
sbdtu5498@sbdtu5498-TUF-Gaming-FX505DT-FX505DT:~/Videos/Personal Stuff$ kubectl get volumesnapshot velero-mattermost-team-edition-d4l78 -n mattermost -o yaml
```

### Migrating the postgress operator to cnpg

1. Backup existing mattermost database.

```sh
pg_dump -c -U mattermost | gzip > mattermost_dbdump_2024-01-15.sql.gz

# Copy the data to local machine
kubectl cp mattermost/mattermost-pgsql-0:/mattermost_dbdump_2024-01-15.sql.gz ./mattermost_dbdump_2024-01-15.sql.gz
```

* Create the PR for migrating postgress operator [kubeaid-config-Reflink](https://gitea.obmondo.com/EnableIT/kubeaid-config-enableit/pulls/1033/files) [Kubeaid-Ref-link](https://gitea.obmondo.com/EnableIT/KubeAid/pulls/592)
* Log in to Argocd and update the manifest, ensuring your branch is set in the targetRevision.
* Review the diff carefully and make sure not to remove the existing PostgreSQL deployment **acid.zalan.do/postgresql/mattermost/mattermost-pgsql**
* Once all the steps above are completed, sync the application in Argocd.
* Confirm that the new pods for mattermost-pgsql-1 and mattermost-team-edition are up and running.
* To copy the database backup to the new PostgreSQL pod, create a new Ubuntu pod within the Mattermost namespace, then import the database from there.

```sh 
vim ubuntu-sleep.yaml ## Add the below content 

apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  labels:
    app: ubuntu
spec:
  containers:
  - image: ubuntu
    command:
      - "sleep"
      - "604800"
    imagePullPolicy: IfNotPresent
    name: ubuntu
  restartPolicy: Always


kubectl apply -f ubuntu-sleep.yaml -n mattermost
```

* Install Postgresql package inside the Ubuntu pod and import the database.

```sh
apt update
apt install postgress
```

* Transfer the backup database file to the Ubuntu pod.
 
```sh
kubectl cp mattermost_dbdump_2024-01-15.sql.gz mattermost/ubuntu:/tmp
cd /tmp
gzip -d mattermost_dbdump_2024-01-15.sql.gz
```

* Retrieve database user password by accessing the secrets (mattermost-pgsql-app) in k9s.
* Obtain the host IP of the Postgres pod from service using k9s.
* Execute the command to import the backup database into PostgreSQL.

```sh
psql -h 10.98.77.222 -p 5432 -d mattermost -U mattermost < mattermost_dbdump_2024-01-15.sql
or 
pg_restore -h 10.98.77.222 -p 5432 -d mattermost -U mattermost < mattermost_dbdump_2024-01-15.sql
```

* Start the mattermost-team-edition application by syncing the deployment from the Argo CD UI.
* Once the application is up and running, log in to Mattermost to confirm that the old chats, uploaded files, and images are accessible.
* After verifying the application works as expected, delete the Ubuntu pod.
