# Postgres-operator

## Summary

-   Postgres-operator was setup to manage Postgres instance as we have also decided not to use postgresql to be provisioned by sonarqube.

-   The ```zalando postgres-operator``` chart - https://github.com/zalando/postgres-operator was used to setup the operator and so it deployed the instance and the feature branch was used for targetRevision.

-   Setting up postgres-operator installs operator and deploys an instance (postgresql) for sonarqube and does not setup postgresql yet.

-   After deploying posgres-operator, a postgresql was provided for sonarqube by inputing its files in ```sonarqube/templates/``` repo.

```bash
apiVersion: "acid.zalan.do/v1"
kind: postgresql
metadata:
  name: obmondo-postgresql
  namespace: sonarqube
spec:
  teamId: obmondo
  volume:
    size: 2Gi
    storageClass: rook-ceph-block
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

-   A PR was made on kubernetes-config enableit repo - https://gitlab.enableit.dk/kubernetes/kubernetes-config-enableit/-/merge_requests/25 and it points to main branch – HEAD. So it is to be merged once the feature branch for postgres-operator + sonarqube config in argocd-apps is merged.

-   The Postgres-operator is instatlled on the ```system``` namespace as it is to be used for MANY postgresql instances - NOT just for  sonarqube.
