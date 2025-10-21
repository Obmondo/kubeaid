# [![Mattermost logo](https://user-images.githubusercontent.com/7205829/137170381-fe86eef0-bccc-4fdd-8e92-b258884ebdd7.png)](https://mattermost.com)

[Mattermost](https://mattermost.com) is an open core, self-hosted collaboration platform that offers chat, workflow automation, voice calling, screen sharing, and AI integration.

# Restore Mattermost / Migration to Another Server

This guide outlines the steps to restore a Mattermost instance or migrate it to a new server.

## Steps

1. **Sync the Mattermost PostgreSQL database first.**

2. **Retrieve Mattermost database credentials from the secret `mattermost-pgsql-app`.**

3. **Create a Kubernetes secret `db-credentials` using the Mattermost database credentials.**

   Use this command to generate the DB connection string for the Mattermost operator:

   ```sh
   kubectl create secret generic db-credentials \
   --from-literal=DB_CONNECTION_STRING="$(kubectl get secret mattermost-pgsql-app -n mattermost-operator -o jsonpath='{.data.uri}' | base64 --decode | sed 's/^postgresql:/postgres:/')"
   --dry-run=client -o yaml
   ```
4. **Download the latest logical backup from S3 and extract it locally.**

   ```sh
   AWS_ACCESS_KEY_ID="mattermost" AWS_SECRET_ACCESS_KEY="secretkey" aws s3 --endpoint https://s3.bucket.com/ cp s3://mattermost-postgres-backups/spilo/logicalbackup/logical_backups/<latest>.sql.gz ./

   gunzip -d <filename>.sql.gz
   ```
5. **Access the `mattermost-pgsql` pod shell and reset the Mattermost database to avoid errors.**

   Connect to the pod and execute
   ```sh
   DROP DATABASE mattermost;
   CREATE DATABASE mattermost OWNER mattermost
   ```

6. **Restore the database from the extracted backup file.**

   Run the restore command:

   ```sh
   psql -h 172.20.36.240 -p 5432 -d mattermost -U mattermost < <backupfile>.sql
   ```
   Note:
   If you are using Mattermost version 10.11.4, the database connection string (DB_CONNECTION_STRING) 
      is stored inside the database configuration.
   After restoring, you must update it with the new PostgreSQL credentials.
   
   ```sh
   # Connect to PostgreSQL
   psql -h 172.20.36.240 -p 5432 -d mattermost -U mattermost

   # Fetch the current connection string
   mattermost=> SELECT ("value"::jsonb)->'SqlSettings'->>'DataSource' AS "DataSource"
   FROM "configurations"
   WHERE "active" = true;
   
   # Example output:
   # postgres://mattermost:zPWjYqmdpRSb01psy4p1uqTHGmT0WVehvm3nHyuDg7eb9K2WhvJNKBOFjo3USKJK@mattermost-pgsql-rw:5432/mattermost
   
   # Update the connection string using the new credentials
   UPDATE configurations
   SET "value" = jsonb_set(
     "value"::jsonb,
     '{SqlSettings,DataSource}',
     to_jsonb('postgres://mattermost:P3abi2rHJqGzYaCXyaw9BdDoCAulMnqGUIDdjgA6fQSA21Yc4HNVcjSn6tQ8J3vf@mattermost-pgsql-rw:5432/mattermost'::text),
     false
   )
   WHERE "active" = true;

   ```

7. **Copy PVC files to the new S3 bucket to restore file storage.**

   If you have access to the node, upload files directly from the PVC mount path using the MinIO client:
   ```sh
   cd /var/lib/kubelet/pods/<pod-uid>/volumes/kubernetes.io~csi/<pvc-name>/mount

   mc alias set mattermost https://s3.bucket.com mattermost <password>

   mc mirror . mattermost/mattermost-backup --overwrite
   ```

8. **After syncing the data and restoring the DB, sync the entire Mattermost instance.**

   The new Mattermost will be restored to the state captured by the backup.

   ---
