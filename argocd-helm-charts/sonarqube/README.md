# Sonarqube

## summary

-   SonarQube is a Code Quality Assurance tool that collects and analyzes source code, and provides reports for the code quality of your project.

-   It is needed to be integrated with CI in order to validate codes.

-   it has been configured to spin up a postgresql instance controlled by the statefulset but for this project, a postgres that depends on postgres-operator being installed - to work has been added to sonarqube repo and the default one is being disabled in the ```values.yaml``` file with:

```bash
sonarqube:
  postgresql:
    enable: false
```


-   The pgsql user to be created is stated in the ```postgres.yaml``` in ```sonarqube/templates``` as ```sonarqube_admin```.

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

The user, password key and secret name was set CORRECTLY under ```jdbcOverwrite``` in order to avoid the ```user authentication failed``` error as we initially had it in the logs.

-   For the current setup, the below is its config:

```bash
jdbcOverwrite:
    enable: true
    jdbcUrl: "jdbc:postgresql://obmondo-postgresql/sonarqube?socketTimeout=1500"
    jdbcUsername: "sonarqube_admin"
    jdbcSecretPasswordKey: password
    jdbcSecretName: sonarqube-admin.obmondo-postgresql.credentials.postgresql.acid.zalan.do
```

The Postgres operator manages the database backup, so we dont need to configure the configmap and cronjob.
