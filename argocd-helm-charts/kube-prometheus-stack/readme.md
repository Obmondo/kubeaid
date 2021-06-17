# Prometheus Kubernetes Stack

Includes alertmanager, grafana etc.

## Resetting password for grafana admin user

shell into grafana pod and run:

```
grafana-cli admin reset-admin-password <newpassword>
```
