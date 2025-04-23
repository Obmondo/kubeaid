# Metal3 - Metal Kubed

Metal3 (pronounced "metal cubed") is an open-source project that provides a comprehensive framework for managing bare metal infrastructure using Kubernetes-native APIs. This helm chart deploys the Metal3 components required for bare metal host provisioning.

## What is Metal3?

Metal3 aims to bring the benefits of Kubernetes declarative management to bare metal servers by treating them as first-class resources in Kubernetes. It provides a seamless, cloud-like experience for managing physical servers while maintaining the full performance benefits of bare metal.

### Core Components

1. **Bare Metal Operator (BMO)** - A Kubernetes controller that manages bare metal hosts represented as `BareMetalHost` custom resources
2. **Ironic** - The OpenStack project that handles the actual provisioning of physical servers
3. **Cluster API Provider Metal3** - Integrates with the Kubernetes Cluster API to enable Kubernetes cluster creation on bare metal servers

## Bare Metal Provisioning Workflow

When using Metal3, the bare metal provisioning process follows these stages:

1. **Host Registration** - The server is registered as a `BareMetalHost` resource in Kubernetes with BMC (Baseboard Management Controller) credentials
2. **Inspection** - Hardware details are automatically discovered and recorded
3. **Cleaning** - Disks are wiped and the system is prepared for provisioning
4. **Provisioning** - An operating system image is deployed to the server
5. **Maintenance/Deprovisioning** - When no longer needed, the server can be cleaned and returned to the available pool

### State Machine

The `BareMetalHost` resource moves through various states during its lifecycle:
- `Registering` → `Inspecting` → `Available` → `Provisioning` → `Provisioned`

And for deprovisioning:
- `Provisioned` → `Deleting` → `Cleaning` → `Available`


## Provisioning Methods

Metal3 supports multiple provisioning methods:

1. **PXE Boot** - Traditional network booting using DHCP and TFTP
   - Requires a dedicated provisioning network
   - Enable with `enable_dnsmasq: true` and `enable_pxe_boot: true`

2. **Virtual Media** - Attaches an ISO image to the server via the BMC
   - No requirement for a dedicated provisioning network
   - Works over the management network
   - Requires Redfish support with Virtual Media capability

All the below requirements and examples are for **BMC** . We can even provision nodes in **VMware** which is WIP.

## Firewall Requirements

The Metal3 provisioning environment involves three main components:
1. **Metal3 Host** - The system running the Metal3 services (Ironic, DHCP, TFTP, HTTP)
2. **BMC** - The Baseboard Management Controller of the physical server
3. **Target Server** - The physical server being provisioned

Ensure your firewall allows the following traffic flows:

### 1. Metal3 Host to BMC Network
| Protocol | Source Port (Metal3 Host) | Destination Port (BMC) | Purpose |
|----------|----------------|----------------|----------------------------|
| TCP | Ephemeral | 443 | HTTPS for Redfish API |
| TCP | Ephemeral | 80 | HTTP for Redfish API |
| UDP | Ephemeral | 623 | IPMI |

### 2. Target Server to Metal3 Host Communication
| Protocol | Source Port (Target Server) | Destination Port (Metal3 Host) | Purpose |
|----------|----------------|----------------|----------------------------|
| UDP | 68 | 67 | DHCP |
| UDP | Ephemeral | 69 | TFTP |
| UDP | Ephemeral | 4011 | ProxyDHCP/iPXE |
| UDP | Ephemeral | 547 | DHCPv6 |
| TCP | Ephemeral | 80, 443 | HTTP/HTTPS |
| TCP | Ephemeral | `vmediaTLSPort`, 6385 (Ironic API) | Ironic endpoints |
| ICMP | N/A | N/A | Echo request (ping) |

### 3. Metal3 Host to Target Server Communication
| Protocol  | Source Port (Metal3 Host) | Destination Port (Target Server) | Purpose |
|-----------|----------------|----------------|------------|
| ICMP | N/A | N/A | Echo request (ping) |
| UDP | 67 | 68 | DHCP (assign IP address) |
| UDP | 69 | Ephemeral | TFTP (PXE boot file transfer) |
| UDP | 4011 | Ephemeral | ProxyDHCP (iPXE boot process) |
| UDP | 547 | Ephemeral | DHCPv6 (IPv6 address assignment) |
| TCP | 80, 443 | Ephemeral | HTTP/HTTPS (serve boot images) |
| TCP | Ephemeral | 6385 | Ironic API (provisioning commands) |
| TCP | Ephemeral | `vmediaTLSPort` | Virtual Media (stream virtual boot media like IPA) |

### 4. BMC Network to Metal3 Host
| Protocol  | Source Port (BMC) | Destination Port (Metal3 Host) | Purpose |
|-----------|----------------|----------------|------------|
| ICMP | N/A | N/A | Echo request (ping) |
| TCP | 80, 443 | Ephemeral | HTTP/HTTPS (serve boot images) |
| TCP | Ephemeral | `vmediaTLSPort` | Ironic endpoint serving boot images|

**Note:** The BMC network is typically a separate management network and does not need the same ports as the provisioning network. The BMC only needs to be accessible via its management protocols (Redfish/IPMI) from the Metal3 Host. The BMC itself does not need to initiate connections to the Metal3 Host or Target Server, except for fetching Ironic Python Agent and other virtual media from `vmediaTLSPort`.

## Network Setup

To set-up Ironic Python Agent networks you need to create a secret with the name `<baremetalhost>-network` which should look like:

```bash
apiVersion: v1
kind: Secret
metadata:
  name: host-0-network
  namespace: metal3
type: Opaque
stringData:
  networkData: |
    interfaces:
    - name: <interface name>
      type: ethernet
      state: up
      mac-address: "<mac-address>"
      ipv4:
        address:
        - ip: <network-interface-ip>
          prefix-length: 24
        enabled: true
        dhcp: false
    dns-resolver:
      config:
        server:
        - <dns-server-ip>
    routes:
      config:
      - destination: 0.0.0.0/0
        next-hop-address: <gateway-ip>
        next-hop-interface: <interface name>
```

To set-up the provisioned server network you should create a secret with the name `<baremetalhost>-networkdata` which should look like:

```bash
{
  "links": [
    {
      "id": "<interface name>",
      "type": "phy",
      "ethernet_mac_address": "<mac-address>"
    }
  ],
  "networks": [
    {
      "id": "<interface name>",
      "link": "<interface name>",
      "type": "ipv4",
      "routes":
        {
          "network": "<network-interface-ip>",
          "netmask":  "255.255.255.0",
          "gateway": "<gateway-ip>"
        }
    }
  ],
  "services": []
}
```

## Userdata setup

If we want to configure the partion or create users or anything in the server on the first boot - we need to create a secret `<baremetalhost>-userdata`
The below one assigns the hostname to the server, creates a sudo user and make sure the `/` partition is 50G.

```bash
#cloud-config

hostname: tdkcphsmn01

users:
  - name: test
    groups: [sudo]
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    lock_passwd: false
    passwd: $6$4Ku44dv4Gh4vE/l/$hvcWyIb6SyL2huyQ/cPVNjya0g30tcpryiYSPNWavIVAxGMOFp2l7RHB0mBgAe.I149w1SloBmGNnjwICIx1M/

growpart:
  mode: 'off'

runcmd:
  - echo yes | parted /dev/nvme2n1 ---pretend-input-tty resizepart 1 50GB
  - resize2fs /dev/nvme2n1p1
```

`/dev/nvme2n1` is the same disk where you have set the `rootDeviceHints` for.

## Further Resources

- [Metal3 Website](https://metal3.io)
- [Metal3 User Guide](https://book.metal3.io)
- [Ironic Documentation](https://docs.openstack.org/ironic/latest/)
- [Redfish Specification](https://www.dmtf.org/standards/redfish)
