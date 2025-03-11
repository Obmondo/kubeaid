## How to Enable Provisioning Network

By default PXE boot functionality is disabled, so deployments via e.g redfish-virtualmedia may
be performed without any dedicated provisioning network.

For PXE boot a dedicated network is required, in this case we run a dnsmasq instance to provide
DHCP and require a dedicated NIC for connectivity to the provisioning network on each host.

To enable this mode you must provide the following additional configuration (note the values are
examples and will depend on your environment):

```
global:
  enable_dnsmasq: true
  enable_pxe_boot: true
  dnsmasqDefaultRouter: 192.168.21.254
  dnsmasqDNSServer: 192.168.20.5
  dhcpRange: 192.168.20.20,192.168.20.80
  provisioningInterface: ens4
  provisioningIP: 192.168.20.5
```

Note that these values *must not* conflict with your controlplane or other networks otherwise unexpected
behavior is likely - a dedicated physical network is required in this configuration.
