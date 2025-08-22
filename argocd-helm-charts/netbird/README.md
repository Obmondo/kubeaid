# Netbird Installation

This document outlines the steps to customize the Helm installation for Coturn and Netbird services.
The modifications include changing the Coturn service type and setting up ingress for all Netbird services.

Refer the example [values.yaml](./examples/values.yaml) for additional configurations.
You can simply copy-paste the values file in your kubeaid-config, and replace the necessary values to get netbird working.

## Modify Coturn Service Configuration

This will enable peer discovery.

```yaml
coturn:
  service:
    type: NodePort
    externalTrafficPolicy: Cluster
```

## Set Up Ingress for Netbird Services

This will use gRPC protocol.

```yaml
netbird:
  <service-name>:
    service:
      port: 80
    ingress:
      enabled: true
      annotations:
        traefik.ingress.kubernetes.io/service.serversscheme: h2c
      className: traefik-cert-manager
      tls:
        - hosts:
            - vpn.example.com
          secretName: vpn.example.com
      hosts:
        - host: vpn.example.com
          paths:
            - path: <ingress-path>
              pathType: ImplementationSpecific
```
