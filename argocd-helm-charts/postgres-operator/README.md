# Postgres-operator

## Summary

-   Postgres-operator is used to manage Postgres instances, including high-availability setups with master and multiple slaves, and automatic failover and backups of data to offsite location.

-   Here is an example of how to setup a postgresql instance, using this operator:

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

-   The Postgres-operator is instatlled on the ```system``` namespace as it is to be used for MANY postgresql instances.
