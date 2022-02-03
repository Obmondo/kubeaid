# Postgres-operator

## Summary

Postgres-operator is used to manage Postgres instances, including high-availability setups with master and multiple slaves, and automatic failover and backups of data to offsite location.

Here is an example of how to setup a postgresql instance, using this operator:

```bash
apiVersion: "acid.zalan.do/v1"
kind: postgresql
metadata:
  name: teamname-postgresql
  namespace: sonarqube
spec:
  teamId: teamname
  volume:
    size: 2Gi
  numberOfInstances: 1
  users:
    sonarqube_admin: # database owner
      - superuser
      - createdb
    sonarqube_test: []
  databases:
    sonarqube: sonarqube_admin
  postgresql:
    version: "13"
  enableMasterLoadBalancer: false
```

NB. The Postgres-operator is instatlled in the ```system``` namespace as it is to be used for MANY postgresql instances - preferrably ALL in the cluster - so backup and high-availability works the same for all.

Example per-cluster values for AWS cluster:
```
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