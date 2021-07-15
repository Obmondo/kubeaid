# Prometheus Kubernetes Stack

Includes alertmanager, grafana etc.

## Resetting password for grafana admin user

shell into grafana pod and run:

```
grafana-cli admin reset-admin-password <newpassword>
```

## Access prometheus container
```
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 8080:9090
```

## Access alertmanager container
```
kubectl port-forward -n monitoring svc/kube-prometheus-stack-alertmanager 8081:9093
```
