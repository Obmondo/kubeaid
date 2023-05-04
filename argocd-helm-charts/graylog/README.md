# Graylog docs

## Add the graylog username and password into sealed secret

```sh
# pwgen 20 1 | tr -d '\n' > graylog-password
# cat graylog-password | sha256sum | tr -d '\n' > graylog-sha2
# kubectl create secret generic graylog -n graylog  --dry-run=client --from-file=graylog-password-secret=./graylog-password --from-file=graylog-password-sha2=./graylog-sha2 -o json >graylog.json
# kubeseal --controller-name sealed-secrets --controller-namespace system < graylog.json > graylog-final.json
```

**TODO:** Add infomation about creating the graylog-es-svc secret

## Port forwarding to access the Graylog

**Note: this is handy when authentication via header is enabled.**

```sh
kubectl port-forward -n graylog svc/graylog 9091:9000
```

## set admin password (in standalone setup)

Helm chart takes care of converting the password into `sha256` hash. [configure](https://docs.graylog.org/en/4.0/pages/getting_started/configure.html)

```sh
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
```

Push this new string out in graylog secret - key graylog-password-sha2

## Beats input

To create Beats input, go to the web interface:

* Go to the inputs page (Menu bar->System->Inputs)
* In the "Select input" drop down menu, select "Beats"
* Click "Launch new input"
* Enter the following in the form:
  * Title: Beats
  * Port: 5044
  * Enable the "Do not add Beats type as prefix" option, at the bottom
* Click "Save"

## Index and log retention configuration

* Go to the "Configure Index Set" page (Menu bar->System->Indices)
* Click the `edit` button, next to the "Default index set"
* In the "Index Rotation Configuration" section
  * Select rotation strategy: `Index Time`
  * Rotation period: `P1D`
* In the "Index Retention Configuration" section
  * Select retention strategy: `Delete Index`
  * Max number of indices: `180`

## trigger index cycle now (instead of at night)

```sh
curl -XPOST http://127.0.0.1:9000/api/system/deflector/cycle -H 'X-Requested-By: localhost'
```

login (user+password) can be found in secret called graylog - field `data.graylog-password-secret`

## Connecting MongoDB

Graylog needs to connect to MongoDB to store configs. This chart uses the MongoDB operator to
add a database by creating an object of `kind: MongoDBCommunity`.

The object also tells the operator to create a separate `graylog` database
and a `graylog-user` with `readWrite` permissions. It expects a secret `graylog-user-password`
containing the password which will be used by graylog client later.

The connection string for the graylog client is generated and kept in a secret
called `mongodb-replica-set-graylog-graylog-user`. The string is of the form :

```bash
mongodb://graylog-user:<password>@mongodb-replica-set-0.mongodb-replica-set-svc.graylog.svc.cluster.local:27017/graylog?replicaSet=mongodb-replica-set&ssl=false
```

This username and password combination allows the Graylog client to authenticate itself to the MongoDB instance.

**NOTE: Do not use `userAdminAnyDatabase` role of MongoDB as it does not have permissions to create index.**

Create the mongodb graylog-user password

```bash
kubectl create secret generic graylog-user-password -n default --dry-run=client --from-literal=password=lolpassword -o yaml
```

## Opensearch (elasticsearch fork with open source license)

```bash
kubectl create secret generic graylog-es-svc -n graylog --from-literal=url='http://admin:admin@opensearch-cluster-master:9200' -o yaml
```

## Upgrade Instruction

* Take backup of mongodb
  a. Login on mongodb-replica-set pods shell
  b. and run these commands

  ```bash
  cd /tmp
  mongo dump
  ```

* Check the version of opensearch and mongodb which are supported by graylog
  (there is a link on their website, cant find one now)
* few things to look for, for now I have fixed locally on k8id repo
  a. [issue#104](https://github.com/KongZ/charts/issues/104)
* With graylog 4.3.x and opensearch 1.x we can disable the emulation(ES 7.x - set in opensearch values)
* external url `externalUri` in graylog values should include `https://your-domain.com`
* After the upgrade check the graylog pod and UI for any errors .

## Restore Instruction

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

## Troubleshooting

* if you have upgraded mongodb to 5.x and downgraded to mongodb 4.x you would end up with
  [this error](https://github.com/Graylog2/graylog2-server/issues/13999)
