# Cerebro

Cerebro is an open source (MIT License) elasticsearch web admin tool built using Scala, Play Framework, AngularJS and Bootstrap.

## Introduction

This chart deploys Cerebro to your cluster.

Optionally you can use cerebro provided auth by uploading a Secret with the needed env vars (don't forget to set `AUTH_TYPE`).

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

Please refer to https://artifacthub.io/packages/helm/wiremind/cerebro?modal=install.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Please refer to values.yaml or [Artifact Hub UI](https://artifacthub.io/packages/helm/wiremind/cerebro?modal=values-schema) to see parameters and their default values.

A YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f my-values.yaml stable/cerebro
```

## Backend connection with basic auth

You can create your secret, make sure the key name is "application.conf" and simply give the secret name `configFromSecretRef:`

> **Tip**: You can use the default [values.yaml](values.yaml)
