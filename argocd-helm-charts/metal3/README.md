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

## BareMetalHost Setup

To setup the baremetal host we need deploy the baremetal host and other secrets like network data, preprovisionning-networkdata, userdata.
The example templates for all these can be found [here](./examples/)

To generate these templates correctly the values are provided in the values file [here](./values.yaml)

### Detailed overview of bmh variables

| Variable  | Explanation |
|-----------|----------------|
| mac | MAC address |
| network.interface | Server interface where you want to attach your ip address |
| network.ipaddress | IP address of the server |
| network.dnsserver | DNS server IP address |
| network.gatewayIP | Gateway IP address |
| network.netmask | Netmask IP address |
| os.name | Name of the OS which you want to provision, right now we only support Ubuntu 24.04.2 and RHEL servers |
| os.version | Version of the OS |
| os.url | URL of the OS image which you want to install, right now its only valid for RHEL servers |
| os.checksum | URL of the checksum, right now its only valid for RHEL servers|
| bmc | BMC IP Address |
| secretName | Secret name which stores your username and password to connect to BMC |
| rootPassword | root password of the server |
| rootDeviceSerialNumber | Serial number of the disk where you want your root to be mounted to |
| createpartition | Where you want to create a partion or not |
| partition.diskname | Disk name which you want to partition |
| partition.size | Size of the parition |
| partition.number | Partition number |


For Ubuntu servers we right now only support ubuntu 24.04.2 and it by default takes the OS url and checksum since those are available directly and can be found [here](https://cloud-images.ubuntu.com)

For RHEL servers, the download link is https://access.redhat.com/downloads/content/rhel. You need to pick the kvm.qcow2 image.
What we have done is we downloaded the image on one of the server available over the private url, something like http://10.1.13.1:8080/rhel/8.10/rhel-8.10-x86_64-kvm.qcow2

You can then create the checksum by running

```bash
sha256sum rhel-8.10-x86_64-kvm.qcow2
```

And can then provide the checksum url something like http://http://10.1.13.1:8080/rhel/8.10/rhel-8.10-x86_64-kvm/SHA256SUMS


`secretName` is the Secret name which stores your username and password to connect to BMC. This needs to be present as a secret in your cluster

```bash
password: kwugfi
username: abc
```

## Further Resources

- [Metal3 Website](https://metal3.io)
- [Metal3 User Guide](https://book.metal3.io)
- [Ironic Documentation](https://docs.openstack.org/ironic/latest/)
- [Redfish Specification](https://www.dmtf.org/standards/redfish)
