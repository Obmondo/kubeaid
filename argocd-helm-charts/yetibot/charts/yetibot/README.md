# Yetibot Helm

Yetibot Helm makes it easy to install Yetibot on a
[Kubernetes](https://kubernetes.io/) cluster.

## Usage

```bash
# add the yetibot helm chart repo
helm repo add yetibot https://yetibot.com/yetibot-helm/
# update to get latest charts
helm repo update
# make sure yetibot chart is listed
helm search repo yetibot

# if you want to remove the repo:
helm repo remove yetibot
```

To install (or upgrade if already installed):

```bash
helm upgrade --ns yetibot -f values.yaml -i yetibot yetibot/yetibot
```

## Postgres

Yetibot requires a Postgres instance, and specifies the
[bitnami/postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql/)
chart as a dependency. It is configured in `values.yaml`, which can be overriden.

## Configuration

Though Yetibot can be configured via both environment vars or EDN, this chart
only exposes ENV-based configuration for simplicity. Env vars are settable in
`values.yaml`, which means you can set your own values override via all
available mechanisms that helm provides (typically `--set` or `-f values.yaml`).

Every key/value pair is settable under `yetibot.env`, e.g.:

```bash
helm install . \
  --namespace yetibot-test \
  --set yetibot.env.YB_URL=https://my-yeti.com \
  yetibot/yetibot
```

It's recommended to copy the default [values.yaml](values.yaml) and configure it
locally.

At a minimum you need to configure at least 1 adapter. For example, to connect
to IRC you could set:

```yaml
yetibot:
  env:
    YB_ADAPTERS_MYIRC_TYPE: irc
    YB_ADAPTERS_MYIRC_USERNAME: yetihelm
    YB_ADAPTERS_MYIRC_HOST: chat.freenode.net
    YB_ADAPTERS_MYIRC_PORT: "7070"
    YB_ADAPTERS_MYIRC_SSL: "true"
```

`values.yaml` demonstrates a few configuration options, but see
[sample.env](https://github.com/yetibot/yetibot.core/blob/master/config/sample.env)
for the full set of all available configuration.

## Ops

### Connect a local psql terminal

Forward the postgresql port in order to connect locally using `psql`. Note:
we're using `6543` instead of standard `5432` in order to not interfere with any
local Postgres instance you may be running:

```bash
kubectl --ns yetibot port-forward yetibot-postgresql-0 6543:5432
```

Now connect to Postgres at:

```bash
postgresql://yetibot:yetibot@localhost:6543/yetibot
```

NB: if you changed the credentials update them in the connection string above.

### Recreate the database

If you want to recreate the database from scratch:

```bash
# login to the pod and psql there as an alternative to forwarding the port:
kc exec -it yetibot-postgresql-0 psql postgresql://yetibot:yetibot@localhost:5432/yetibot
# login with the admin postgres user instead
kc exec -it yetibot-postgresql-0 -- psql -U postgres
DROP DATABASE yetibot;
CREATE DATABASE yetibot WITH OWNER = yetibot;
```

Notes:

- you need to admin on the db in order to do this. This depends on how you
  configured the `postgresql` subchart. You may need to use the `postgres` user
  (and set a password on it).
- if you apply new credentials configuration to the `postgresql` chart, they
  will probably not apply unless you delete the pvc and recreate everything. See
  [this GitHub issue](https://github.com/helm/charts/issues/16251) for more
  context.

### Database backup

Follow above instructions for forwarding the `psql` port, then:

```bash
timestamp=`date +'%s'`
filename="$timestamp-yetibot-backup.sql"
echo $filename
pg_dump postgresql://yetibot:yetibot@localhost:6543/yetibot > "$filename"
```

### Database restore

Follow above instructions for forwarding the `psql` port, then:

```bash
filename="" # ensure this is a path to a valid .sql file
psql postgresql://yetibot:yetibot@localhost:6543/yetibot < $filename
```

## Dev setup

### Push chart

The chat is automatically pushed to the Chart repo on GitHub Pages on every
master build, using the [chart-releaser-action](https://github.com/helm/chart-releaser-action)
for GitHub.

### Lint

```bash
helm repo list
helm lint
```

You should see now see `yetibbot` in :

```bash
helm repo list
helm search repo
```

### Minikube

If you want to fully test out the Helm chart locally, you can use an existing
cluster or run locally on
[Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/).

### Check the rendered templates with dry run

```bash

helm install yetibot charts/yetibot \
  --namespace yetibot-test \
  --dry-run

# it can be useful to inspect only a subset of the output. For example, if we
# want to look at the configmap:

helm install yetibot charts/yetibot \
  --namespace yetibot-test \
  --dry-run | grep ConfigMap -A30

```

### Install

If everything looks good, install (this example installs it in the `yetibot`
namespace):

```bash
helm upgrade -n yetibot -i yetibot charts/yetibot
```

### Uninstall

If you want to delete all resources:

```bash
helm -n yetibot delete yetibot
```

*NB*: This does not delete PVCs. You can clean those up using `kubectl delete`.

### Postgres

To get the password for the postgres database, run:

```bash
export POSTGRES_PASSWORD=$(kubectl get secret --ns yetibot psql-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

# run a pod in cluster as a psql client:
kubectl --ns yetibot run psql-postgresql-client \
  --rm --tty -i --restart='Never' \
  --image docker.io/bitnami/postgresql:11.7.0-debian-10-r51 \
  --env="PGPASSWORD=$POSTGRES_PASSWORD" \
  --command -- psql --host psql-postgresql -U yetibot -d yetibot -p 5432
```

### Cheat sheet

```bash
helm upgrade -n yetibot -i yetibot charts/yetibot

helm -n yetibot delete yetibot

helm -n yetibot list

kc delete all

kcd statefulset yetibot-postgresql-0

kc get pvc

kc delete pvc data-yetibot-postgresql-0

kc get po
kc get po -w

kc exec -it yetibot-postgresql-0 sh

# then inside the pod, verify psql:

PGPASSWORD="$POSTGRES_PASSWORD" psql -U yetibot -d yetibot
```

### Lint with ct

Use [`chart-testing`](https://github.com/helm/chart-testing/releases) Docker
image:


```bash
# poke around manually:
docker run -it --rm --name ct \
  --volume $(pwd):/data quay.io/helmpack/chart-testing:v2.3.0

cd /data
ct lint --all --config ct.yaml --debug

# or run it all in one go:
docker run -it --rm --name ct \
  --volume $(pwd):/data quay.io/helmpack/chart-testing:v2.3.0 \
  sh -c "cd /data && ct lint --all --config ct.yaml --debug"
```
