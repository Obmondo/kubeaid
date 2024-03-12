# Prometheus Monitoring Mixin for RabbitMQ

A set of Grafana dashboards and Prometheus alerts and rules for RabbitMQ.

## Requirements

These dashboards and alerts are based of on [detailed RabbitMQ metrics](https://github.com/rabbitmq/rabbitmq-server/blob/master/deps/rabbitmq_prometheus/metrics-detailed.md) that are not scraped out of the box. To scrape them you'll need an additional scraping path alongside the default path:

- `/metrics/detailed?family=queue_coarse_metrics&family=queue_consumer_count`

Below is an YAML example using the Prometheus Operators' ServiceMonitor CRD.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app.kubernetes.io/instance: rabbitmq
    app.kubernetes.io/name: rabbitmq
  name: rabbitmq-detailed
  namespace: production
spec:
  endpoints:
  - interval: 30s
    params:
      family:
      - queue_coarse_metrics
      - queue_consumer_count
    path: /metrics/detailed
    port: metrics
  namespaceSelector:
    matchNames:
    - production
  selector:
    matchLabels:
      app.kubernetes.io/instance: rabbitmq
      app.kubernetes.io/name: rabbitmq
```

## How to use

This mixin is designed to be vendored into the repo with your infrastructure config.
To do this, use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler):

You then have three options for deploying your dashboards

1. Generate the config files and deploy them yourself
2. Use jsonnet to deploy this mixin along with Prometheus and Grafana
3. Use prometheus-operator to deploy this mixin

## Generate config files

You can manually generate the alerts, dashboards and rules files, but first you
must install some tools:

```sh
go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
brew install jsonnet
```

Then, grab the mixin and its dependencies:

```sh
git clone https://github.com/adinhodovic/rabbitmq-mixin
cd example/rabbitmq-mixin
jb install
```

Finally, build the mixin:

```sh
make prometheus-alerts.yaml
make prometheus-rules.yaml
make dashboards-out
```

The prometheus-alerts.yaml and prometheus-rules.yaml file then need to passed to your Prometheus server, and the files in dashboards-out need to be imported into you Grafana server. The exact details will depending on how you deploy your monitoring stack to Kubernetes.

## Alerts

The mixin follows the [monitoring-mixins guidelines](https://github.com/monitoring-mixins/docs#guidelines-for-alert-names-labels-and-annotations) for alerts.
