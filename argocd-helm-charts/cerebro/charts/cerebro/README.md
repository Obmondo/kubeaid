# Cerebro

Cerebro is an open source (MIT License) elasticsearch web admin tool built using Scala, Play Framework, AngularJS and Bootstrap.

## Introduction

This chart deploys Cerebro to your cluster via a Deployment and Service.
Optionally you can also enable ingress.
Optionally you can use cerebro provided auth by uploading a Secret with the needed env vars (don't forget to set `AUTH_TYPE`).

# Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release wiremind/cerebro
```

After a few seconds, you should see service statuses being written to the configured output.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Please refer to values.yaml to see parameters and their default values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    stable/cerebro
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/cerebro
```

## Backend connection with basic auth

You can create your secret, make sure the key name is "application.conf" and simply give the secret name `configFromSecretRef:`

> **Tip**: You can use the default [values.yaml](values.yaml)
