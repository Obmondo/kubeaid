# Pod Autoscaling with KEDA Project

**NOTE: Do not combine KEDA Project's autoscaling (described in this guide) with Kubernetes HPA + Prom Adapter
for the same pod deployment. They will compete with each other and break things.**

**NOTE2: This assumes your cluster is setup with K8id because it provides sane defaults, although its possible to setup
this on non K8id clusters too.**

For new setups, we recommend using KEDA Project for Pod Autoscaling instead of Prometheus Adapter because
it is much easier to wrap your head around it compared to Prometheus Adapter where you have to define
rules, metric to resource association, etc.

## Introduction & Situation

- Your application (running on K8s via a `Deployment` of pods) exposes metrics on an http endpoint.
- There is a `Service` for that deployment.
- There is a `ServiceMonitor` (K8s resource) for that service that tells Prometheus that it needs to scrape metrics
  from that service.

## Setup Prerequisites

Set `connect_keda: true` in your k8id managed cluster's prometheus build jsonnet vars file
`(k8id-config/k8s/<clustername>/<clustername>-vars.jsonnet)`.

Regenerate kube prometheus YAML with
`k8id/build/kube-prometheus/build.sh /path/to/k8id-config/k8s/<clustername>/<clustername>-vars.jsonnet`

This will generate a few YAML files which define the network policy which allows Keda to connect to prometheus.

Create `k8id-config/k8s/<clustername>/argocd-apps/templates/keda.yaml`.
Replace the repo URLs with your own.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: keda
  namespace: argocd
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: monitoring
  project: default
  sources:
    - repoURL: https://gitlab.enableit.dk/kubernetes/k8id.git
      path: argocd-helm-charts/keda
      targetRevision: HEAD
      helm:
        valueFiles:
          - $values/k8s/kbm.obmondo.com/argocd-apps/values-keda.yaml
    - repoURL: https://gitea.obmondo.com/EnableIT/kubernetes-config-enableit.git
      targetRevision: HEAD
      ref: values
  syncPolicy:
    automated: null
    syncOptions:
      - CreateNamespace=true
      - ApplyOutOfSyncOnly=true
```

Create a values file `k8id-config/k8s/<clustername>/argocd-apps/values-keda.yaml`. Leave it empty for now.

Commit the changes to your cluster config repo and sync.

KEDA project provides the `external.metrics.k8s.io` API which is different from `custom.metrics.k8s.io` provided by
Prometheus Adapter. Both APIs have the same desired usecase but work in a different way.

You should now see `external.metrics.k8s.io` as _running_ in the output of `kubectl api-versions`.

## Autoscaling HPA based on CPU/Memory and Custom Metrics

You have to create a `ScaledObject`. DO NOT create a resource of kind `HorizontalPodAutoscaler` manually.
`ScaledObject` wraps it and will create it automatically.

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: intensive-app
spec:
  scaleTargetRef:
    kind: Deployment
    name: intensive-app
  pollingInterval: 30
  cooldownPeriod: 300
  minReplicaCount: 1
  maxReplicaCount: 4
  advanced:
    horizontalPodAutoscalerConfig:
      behavior:
        scaleDown:
          stabilizationWindowSeconds: 10
        scaleUp:
          policies:
            - type: Percent
              value: 100
              periodSeconds: 15
          selectPolicy: Max
          stabilizationWindowSeconds: 0
  triggers:
    - type: prometheus
      metadata:
        serverAddress: http://prometheus-k8s.monitoring.svc:9090
        query: sum(autoscaleexp_custom_metric{deployment="intensive-app"}) + sum(another_custom_metric{deployment="intensive-app"})
        threshold: "100"
    - type: cpu
      metricType: Utilization
      metadata:
        value: "50"
```

The result of your query is compared against the threshold. **It should return a single element response.**

## Algorithm Behavior

- If you have multiple triggers, for example one trigger for CPU, one for memory and another
  for a prometheus query and each returns a different desired replica count then the maximum of those will be chosen.
- You can configure Stabilization window and Scaling policies to change how much time to wait before scaling and
  how fast should it scale.

## Reference Links

- https://keda.sh/docs/2.10/concepts/scaling-deployments/
- https://keda.sh/docs/2.10/scalers/prometheus/
- https://keda.sh/docs/2.10/scalers/cpu/
- https://keda.sh/docs/2.10/scalers/memory/
