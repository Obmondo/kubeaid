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
