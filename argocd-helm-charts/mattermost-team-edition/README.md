
# Migrate mattermost-team-edition to k8S

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
