
# Migrate mattermost-team-edition to k8S  

## Follow to Enable Keycloak SSO (OAuth) for Mattermost Teams Edition

## Configure Mattermost config values**

```text
MM_GITLABSETTINGS_ENABLE: "true"
MM_GITLABSETTINGS_USERAPIENDPOINT: "https://<keycloak-domain>/auth/realms/<realm-name>/protocol/openid-connect/userinfo"
MM_GITLABSETTINGS_AUTHENDPOINT: "https://<keycloak-domain>/auth/realms/<realm-name>/protocol/openid-connect/auth"
MM_GITLABSETTINGS_TOKENENDPOINT: "https://<keycloak-domain>/auth/realms/<realm-name>/protocol/openid-connect/token"
MM_GITLABSETTINGS_ID: ""
MM_GITLABSETTINGS_SECRET: ""
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
