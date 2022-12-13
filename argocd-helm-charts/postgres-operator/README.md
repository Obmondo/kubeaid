# Postgres-operator

## Summary

Postgres-operator is used to manage Postgres instances, including high-availability setups with master and
multiple slaves, and automatic failover and backups of data to offsite location.

Example [postgres-cluster](./examples/postgres-cluster.yaml)

### how to setup a postgresql cluster instance on diff providers

* [AWS](./examples/aws.yaml)
* Setup the values files for baremetal server
  NOTE: currently its not possible to setup the secret directly in postgres operator which will pass
  the env variable to backup pods. [More info](https://github.com/zalando/postgres-operator/pull/2097)
  * [Physical](./examples/baremetal.yaml)
  * Create the secret for accessing self-hosted s3

  ```sh
  kubectl create secret generic $postgres-cluster-name-postgres-pod-env -n $namspace-where-is-your-postgres-cluster-deployed --dry-run=client --from-literal=AWS_SECRET_ACCESS_KEY=boolol -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets -o yaml > /path/to/sealed-secret/dir/$postgres-cluster-postgres-pod-env.yaml
  ```

  * Setup the s3 profile

  ```raw
  # cat ~/.aws/config
  [profile obmondo] -> you can give any name to your profile
  region = us-east-1
  ```

  ```raw
  # cat ~/.aws/credentials
  [obmondo]
  aws_access_key_id = your_key_id
  aws_secret_access_key = your_secret_key
  ```

  ```sh
  export AWS_PROFILE=obmondo
  ```

  * Create the bucket manually

  ```sh
  # aws s3api create-bucket --bucket kbm-postgres-buckets --region eu-west-1 --endpoint-url=https://s3.obmondo.com
  {
    "Location": "/kbm-postgres-buckets"
  }

  # aws s3api list-buckets --region eu-west-1 --endpoint-url=https://s3.obmondo.com
  ```

  * Add the secret in the respective values files

  ```yaml
  postgresql:
    access_secret: keycloakx-pgsql-postgres-pod-env
  ```

  * The postgres cluster pod should be restarted, if not you can safely reboot the secondary node

  ```sh
  envdir "/run/etc/wal-e.d/env" wal-g backup-list
  ```

  * To start a manual backup, get a shell access to postgres cluster pod, [more info](https://postgres-operator.readthedocs.io/en/latest/administrator/#wal-archiving-and-physical-basebackups)

  ```sh
  su - postgres
  envdir "/run/etc/wal-e.d/env" /scripts/postgres_backup.sh "/home/postgres/pgdata/pgroot/data"
  ```

## Troubleshooting

* `PersistentVolume is filling up`
  or
  `FATAL:  could not write lock file "postmaster.pid": No space left on device`

  * Increase the [volume size](https://postgres-operator.readthedocs.io/en/latest/user/#increase-volume-size)

## Notes

* Depending on the chart please check what database env variables are getting used. And provide those values through
[values.yaml](../keycloak/values.yaml).

* Create the `postgresql.yaml` file in `templates` directory of umbrella chart.
So that postgres-operator will use that to manage the instance

* Also check this [example](../keycloak/templates/postgresql.yaml) for postgresql.yaml file

* Also check example of mattermost setup for [postgresql](../mattermost-team-edition/templates/postgresql.yaml) and the corresponding

* [values.yaml](../mattermost-team-edition/values.yaml) file
