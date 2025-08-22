# Netbird Installation

This Helm chart is for self hosting [Netbird](https://netbird.io).

This document outlines the steps to customize the Helm installation for Coturn and Netbird services with KeyCloak IdP.

Refer the example [values.yaml](./examples/values.yaml) for additional configurations.
You can simply copy-paste the values file in your kubeaid-config, and replace the necessary values to get Netbird working.

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
      port: <service-port>
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

## Connect with peers

Install netbird cli and connect to netbird vpn.

```sh
$ netbird up --management-url https://vpn.example.com:443 --admin-url https://vpn.example.com
Connected
```

Check peers connected and connect to them

```sh
$ netbird status -d                                                                          
Peers detail:
 thinkpad.netbird.selfhosted:
  NetBird IP: <sensitive>
  Public key: <sensitive>
  Status: Idle
  -- detail --
  Connection type: P2P
  ICE candidate (Local/Remote): -/-
  ICE candidate endpoints (Local/Remote): -/-
  Relay server address: 
  Last connection update: 3 seconds ago
  Last WireGuard handshake: -
  Transfer status (received/sent) 0 B/0 B
  Quantum resistance: false
  Networks: -
  Latency: 0s

 precision.netbird.selfhosted:
  NetBird IP: <sensitive>
  Public key: <sensitive>
  Status: Connected
  -- detail --
  Connection type: P2P
  ICE candidate (Local/Remote): host/host
  ICE candidate endpoints (Local/Remote): <sensitive>/<sensitive>
  Relay server address: 
  Last connection update: 1 second ago
  Last WireGuard handshake: 1 second ago
  Transfer status (received/sent) 124 B/180 B
  Quantum resistance: false
  Networks: -
  Latency: 146.790093ms

Events:
  [INFO] SYSTEM (0a22a9fe-e3ea-499e-8912-a59cbb211e62)
    Message: Network map updated
    Time: 3 seconds ago
OS: linux/amd64
Daemon version: 0.55.1
CLI version: 0.55.1
Profile: default
Management: Connected to https://vpn.example.com:443
Signal: Connected to https://vpn.example.com:443
Relays: 
  [stun:stun.vpn.example.com:3478] is Available
  [turn:turn.vpn.example.com:3478?transport=udp] is Unavailable, reason: allocate: Allocate error response (error 401: Unauthorized)
  [rels://vpn.example.com:443/relay] is Available
Nameservers: 
FQDN: viljkid.netbird.selfhosted
NetBird IP: <sensitive>
Interface type: Kernel
Quantum resistance: false
Lazy connection: false
Networks: 10.96.0.0/16
Forwarding rules: 0
Peers count: 1/2 Connected
```

## Troubleshooting

### GET /api/users status 401

Netbird caches the Keycloak users locally. If it is not able to fetch the users from Keycloak, it throws an error with

```log
unable to get keycloak token, statusCode 401
```

**Solution:**

- Set the log level to Debug for the netbird-management pod with `--log-level=debug` as the container arg
- Check the pod logs about token not found
- Check if the service account `netbird-backend` has the permission to `view-users` in Keycloak
- Check if the `AdminEndpoint` in the IdPManagerConfig is correct `https://keycloak.example.com/auth/admin/realms/netbird`

Once this is correct, Netbird pod should be able to warm up the cache and fetch user IDs.

## References and External Links

- https://docs.netbird.io/about-netbird/how-netbird-works
- https://docs.netbird.io/selfhosted/identity-providers#keycloak
- https://docs.netbird.io/selfhosted/troubleshooting
