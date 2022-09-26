# Postgres-operator

## Summary

Postgres-operator is used to manage Postgres instances, including high-availability setups with master and
multiple slaves, and automatic failover and backups of data to offsite location.

Here is an example of how to setup a postgresql instance, [using this operator](./examples/sample.yaml)

NB. The Postgres-operator is instatlled in the ```system``` namespace as it is to be used for
MANY postgresql instances - preferrably ALL in the cluster - so backup and high-availability works the same for all.

Example per-cluster values for AWS cluster:

```yaml
postgres-operator:
  configAwsOrGcp:
    aws_region: 'eu-west-1'
    kube_iam_role: "arn:aws:iam::438423213058:role/k8s-zalando-operator-dmz"
    wal_s3_bucket: "postgres-backup"
  # setup AWS loadbalancer - so postgres instances can be reachable from other clusters
  configLoadBalancer:
    db_hosted_zone: 'example.tld'
    master_dns_name_format: '{cluster}.{hostedzone}'
    replica_dns_name_format: '{cluster}-repl.{hostedzone}'
    custom_service_annotations:
      service.beta.kubernetes.io/aws-load-balancer-internal: "true"
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
  configLogicalBackup:
    logical_backup_s3_bucket: "postgres-backup"
```

## Troubleshooting

* `PersistentVolume is filling up`
  or
  `FATAL:  could not write lock file "postmaster.pid": No space left on device`

  * Increase the [volume size](https://postgres-operator.readthedocs.io/en/latest/user/#increase-volume-size)

## Notes

* Depending on the chart please check what database env variables are getting used. And provide those values through
[values.yaml](../keycloak/values.yaml).

- Create the `postgresql.yaml` file in `templates` directory of umbrella chart.
So that postgres-operator will use that to manage the instance

- Also check this [example](../keycloak/templates/postgresql.yaml) for postgresql.yaml file

- Also check example of mattermost setup for [postgresql](../mattermost-team-edition/templates/postgresql.yaml) and the corresponding

- [values.yaml](../mattermost-team-edition/values.yaml) file
