# CoreDNS

This helm chart is used to manage custom DNS configurations for CoreDNS while on Azure AKS using GitOps.

## Example Config

```yaml
# values.yaml
customDNS:
  enabled: true
  cache: 30
  dnsServers: >-
    1.1.1.1
    8.8.8.8
  domainList:
    - example.com
    - example.io
    - example.org
```

## References

- https://coredns.io/plugins/forward/
- https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview