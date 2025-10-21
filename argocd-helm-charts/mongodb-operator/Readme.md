# MongoDB Operator

This operator installs the MongoDB Community operator.

To add a MongoDB replicaset,

- create a secret in that namespace
- add a serviceaccount

and apply this YAML of `kind: MongoDBCommunity`.

```yaml
apiVersion: mongodbcommunity.mongodb.com/v1
kind: MongoDBCommunity
metadata:
  name: mongodb-replica-set
  namespace: mongodb
spec:
  members: 1
  type: ReplicaSet
  version: "4.4.0"
  security:
    authentication:
      modes: ["SCRAM"]
  users:
    - name: mongodb-user
      db: admin
      passwordSecretRef: 
        name: mongodb-user-password # the name of the secret we created
      roles: # the roles that we want to the user to have
        - name: readWrite
          db: my-db
      scramCredentialsSecretName: mongodb-replica-set
```

Example of service account :

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mongodb-database
```

# Backup and Restore

* Logical Backups

CronJobs for postgresql logical backup cronjob template can be found [here](./examples/backup-template/mongodb-backup.yaml).

* Mongodb graylog db restore

  a. Delete the graylog statefulset

  ```bash
  kubectl delete sts graylog -n graylog --cascade=orphan
  ```

  b. Delete the graylog pod

  c. Restore the graylog DB

  ```bash
  kubectl cp . graylog/mongodb-replica-set-0:/tmp
  mongorestore  --username graylog-user --password lolpass --authenticationDatabase graylog -d graylog ./tmp
  ```

  d. Sync the graylog pod from argocd

* After upgrade you might now see the old data, to fix this
  a. System
       -> Indices
       -> `click on any indices` or `the one which is missing old data`
       -> Maintenance
       -> 'Recalculate Index Range'`
  b. If you are doing the above for multiple indices, just wait for 1 indices to finish (look at graylog to see)
     and do another one (not compulsory, but hold the horses)

## Enable login via keycloak using traefik-forward-auth

* Go to System -> Authenticators

  ![auth](./static/auth.png)

* Enable Trusted Header Authentication and set the header name to `X-Forwarded-User`
* Create the user on graylog using the same email id as in the keycloak
  ![user](./static/user.png)
* Now you can login to graylog using the keycloak user

## Using Restore Script (supports S3 and Azure blob storage)

The [restore script](./bin/restore.sh) can run in two modes:

- **interactive mode** (default): it asks you for the required input values such as storage provider, credentials, backup file path, and database details.
- **non-interactive mode**: you must set all required environment variables before running the script. If any required variable is missing, the script will fail at validation.

Set `RESTORE_MODE=non-interactive` to run in non-interactive mode.

### Example command for non-interactive mode:

```bash
RESTORE_MODE=non-interactive \
STORAGE_PROVIDER=s3 \
AWS_ACCESS_KEY_ID=your_access_key \
AWS_SECRET_ACCESS_KEY=your_secret_key \
LOGICAL_BACKUP_S3_BUCKET=your_bucket_name \
BACKUP_FILE_PATH=path/to/backup.sql.gz \
LOGICAL_BACKUP_S3_ENDPOINT=https://s3.your-endpoint.com \
DB_NAME=your_db \
DB_USER=your_db_user \
DB_PASS=your_db_password \
DB_HOST=your_db_host \
DB_PORT=5432 \
./restore_script.sh
```

---

### Required Environment Variables

| Variable Name                  | Description                            | Required For           |
|-------------------------------|------------------------------------|-----------------------|
| `RESTORE_MODE`                 | Mode: `interactive` or `non-interactive` | Both                  |
| `STORAGE_PROVIDER`             | Storage backend: `s3` or `azure`   | Both                  |
| **S3 specifics:**              |                                    |                       |
| `AWS_ACCESS_KEY_ID`            | AWS S3 access key ID                | S3                    |
| `AWS_SECRET_ACCESS_KEY`        | AWS S3 secret access key            | S3                    |
| `LOGICAL_BACKUP_S3_BUCKET`     | S3 bucket name                     | S3                    |
| `BACKUP_FILE_PATH`             | Backup file path in bucket          | S3/Azure               |
| `LOGICAL_BACKUP_S3_ENDPOINT`   | S3 service endpoint URL             | S3                    |
| **Azure specifics:**           |                                    |                       |
| `AZURE_STORAGE_ACCOUNT_NAME`   | Azure storage account name          | Azure                 |
| `AZURE_STORAGE_ACCOUNT_KEY`    | Azure storage access key            | Azure                 |
| `AZURE_STORAGE_CONTAINER_NAME` | Azure blob storage container name  | Azure                 |
| `AZURE_STORAGE_BACKUP_PATH`    | Backup blob path                   | Azure                 |
| **Database connection:**       |                                    |                       |
| `DB_NAME`                     | Database name                      | Both                  |
| `DB_USER`                     | Database username                  | Both                  |
| `DB_PASS`                     | Database password                  | Both                  |
| `DB_HOST`                     | Database host address              | Both                  |
| `DB_PORT`                     | Database port                      | Both                  |

---

## Troubleshooting

* if you have upgraded mongodb to 5.x and downgraded to mongodb 4.x you would end up with
  [this error](https://github.com/Graylog2/graylog2-server/issues/13999)
