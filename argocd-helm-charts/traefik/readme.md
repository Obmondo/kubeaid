# Traefik Setup.

## Internal

* We setup an internal service which will have an internal loadbalance IP

### AWS

```yaml
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internel"
```

### AKS

```yaml
service:
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
```

## Public

* We setup an internal service which will have an internet-facing loadbalance IP.
  you will have to add these service annotation in your yaml file

### AWS

```yaml
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
```

### AKS

```yaml
service:
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "false"
    service.beta.kubernetes.io/azure-load-balancer-resource-group: <your-resource-group-name>
```
