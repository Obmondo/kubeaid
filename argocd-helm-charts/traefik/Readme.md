# Traefik - a loadbalancer

## Traefik dashboard

you can access it by doing ```kubectl -n traefik port-forward <podname> 9000:9000```
  and openinghttp://localhost:9000/dashboard/ in your browser

## Setup for Internal use

* We setup an internal service which will have an internal loadbalance IP

### AWS

```yaml
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internal"
```

### AKS

```yamltraefik-zs6m9   0/1     Evicted                  0          60m

service:
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
```

## Public

* We setup an internal service which will have an internet-facing loadbalance IP.
  you will have to add these service annotation in your yaml file

### AWS Public

```yaml
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
```

### AKS Public

```yaml
service:
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "false"
    service.beta.kubernetes.io/azure-load-balancer-resource-group: <your-resource-group-name>
```

### TLS Auth

* [Doc](https://doc.traefik.io/traefik/https/tls/#client-authentication-mtls)
* NOTE: Make sure the key is either ca.crt or tls.ca

```sh
kubectl create secret generic internalca-cert --namespace traefik --dry-run=client --from-file=/path/to/ca.crt -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets -o yaml
```

* Add this in the values file

```yaml
tlsOptions:
  tls-client-auth:
    clientAuth:
      clientAuthType: VerifyClientCertIfGiven
      secretNames:
        - internalca-cert
```

## Troubleshooting

- Traefik has a default limit on Request Body that can affect file uploads. To re-configure it
using a middleware, [see this example.](./examples/request-body-middleware.yaml)

- If you want to run multiple traefik instances, ensure that each traefik deployment has the additional argument
which binds it to a specific ingress class `--providers.kubernetesingress.ingressclass=<ingress-class>`.
This ensures that multiple instances of Traefik don't try to update ingress resources at the same time leading
to the hostname of the ingress switching from one ingress class to another. 