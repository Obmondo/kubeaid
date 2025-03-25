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

## Redfish API and BMC Communication

Metal3 communicates with server hardware through the BMC (Baseboard Management Controller), typically using one of these protocols:

### Redfish API

Redfish is a modern, RESTful API for out-of-band server management. Metal3 uses Redfish to:

- Power servers on/off
- Configure boot devices
- Mount virtual media (ISO images)
- Monitor hardware health
- Access server console

Example Redfish BMC configuration in a `BareMetalHost`:

```yaml
spec:
  bmc:
    address: redfish://<bmc-ip>/redfish/v1/Systems/1
    credentialsName: server1-bmc-credentials
```

#### Redfish API Examples

Here are some practical examples of interacting directly with the Redfish API using curl with basic authentication:

**1. Get System Information**

```bash
# Get basic system information
curl -k -X GET \
  https://<bmc-ip>/redfish/v1/Systems/1 \
  -u admin:password \
  | jq
```

**2. Power Operations**

```bash
# Get current power state
curl -k -X GET \
  https://<bmc-ip>/redfish/v1/Systems/1 \
  -u admin:password \
  | jq '.PowerState'

# Power on a server
curl -k -X POST \
  https://<bmc-ip>/redfish/v1/Systems/1/Actions/ComputerSystem.Reset \
  -H "Content-Type: application/json" \
  -u admin:password \
  -d '{"ResetType": "On"}'

# Power off a server
curl -k -X POST \
  https://<bmc-ip>/redfish/v1/Systems/1/Actions/ComputerSystem.Reset \
  -H "Content-Type: application/json" \
  -u admin:password \
  -d '{"ResetType": "ForceOff"}'
```

**3. Boot Configuration**

```bash
# Set next boot to PXE
curl -k -X PATCH \
  https://<bmc-ip>/redfish/v1/Systems/1 \
  -H "Content-Type: application/json" \
  -u admin:password \
  -d '{"Boot": {"BootSourceOverrideTarget": "Pxe", "BootSourceOverrideEnabled": "Once"}}'

# Set next boot to disk
curl -k -X PATCH \
  https://<bmc-ip>/redfish/v1/Systems/1 \
  -H "Content-Type: application/json" \
  -u admin:password \
  -d '{"Boot": {"BootSourceOverrideTarget": "Hdd", "BootSourceOverrideEnabled": "Once"}}'
```

**4. Virtual Media Operations**

```bash
# Get available virtual media devices
curl -k -X GET \
  https://<bmc-ip>/redfish/v1/Managers/1/VirtualMedia \
  -u admin:password \
  | jq

# Insert ISO image (virtual CD)
curl -k -X POST \
  https://<bmc-ip>/redfish/v1/Managers/1/VirtualMedia/CD/Actions/VirtualMedia.InsertMedia \
  -H "Content-Type: application/json" \
  -u admin:password \
  -d '{"Image": "http://webserver/image.iso", "Inserted": true, "WriteProtected": true}'

# Eject virtual media
curl -k -X POST \
  https://<bmc-ip>/redfish/v1/Managers/1/VirtualMedia/CD/Actions/VirtualMedia.EjectMedia \
  -H "Content-Type: application/json" \
  -u admin:password
```

**5. Hardware Inventory**

```bash
# Get processor information
curl -k -X GET \
  https://<bmc-ip>/redfish/v1/Systems/1/Processors \
  -u admin:password \
  | jq

# Get memory information
curl -k -X GET \
  https://<bmc-ip>/redfish/v1/Systems/1/Memory \
  -u admin:password \
  | jq

# Get disk/storage information
curl -k -X GET \
  https://<bmc-ip>/redfish/v1/Systems/1/Storage \
  -u admin:password \
  | jq
```

**Note:** The exact Redfish API structure may vary between server vendors. The examples above follow the Redfish standard, but you may need to adjust paths or payload formats based on your specific hardware.

### IPMI

For older hardware without Redfish support, IPMI (Intelligent Platform Management Interface) can be used:

```yaml
spec:
  bmc:
    address: ipmi://<bmc-ip>
    credentialsName: server1-bmc-credentials
```

## Provisioning Methods

Metal3 supports multiple provisioning methods:

1. **PXE Boot** - Traditional network booting using DHCP and TFTP
   - Requires a dedicated provisioning network
   - Enable with `enable_dnsmasq: true` and `enable_pxe_boot: true`

2. **Virtual Media** - Attaches an ISO image to the server via the BMC
   - No requirement for a dedicated provisioning network
   - Works over the management network
   - Requires Redfish support with Virtual Media capability

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
    - name: enp1s0f0
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
        next-hop-interface: enp1s0f0
```

To set-up the provisioned server network you should create a secret with the name `<baremetalhost>-networkdata` which should look like:

```bash
{
  "links": [
    {
      "id": "enp1s0f0",
      "type": "phy",
      "ethernet_mac_address": "<mac-address>"
    }
  ],
  "networks": [
    {
      "id": "enp1s0f0",
      "link": "enp1s0f0",
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

## Using Ironic APIs Directly

While Metal3 provides a Kubernetes-native interface, you can also interact directly with the Ironic API for advanced use cases:

### Ironic API Endpoints

- Node management: `http://<ironic-ip>:6385/v1/nodes`
- Image service: `http://<ironic-ip>:<vmediaTLSPort>/images`

### Ironic API Examples Using curl

Here are some practical examples of interacting with the Ironic API using curl:

**1. Node Management**

```bash
# List all nodes with details
curl -X GET http://<ironic-ip>:6385/v1/nodes/detail | jq

# Get information about a specific node
curl -X GET http://<ironic-ip>:6385/v1/nodes/<node-uuid> | jq

# Create a new node
curl -X POST \
  http://<ironic-ip>:6385/v1/nodes \
  -H "Content-Type: application/json" \
  -d '{
    "name": "test-node",
    "driver": "ipmi",
    "driver_info": {
      "ipmi_address": "<bmc-ip>",
      "ipmi_username": "admin",
      "ipmi_password": "password"
    },
    "properties": {
      "cpu_arch": "x86_64",
      "local_gb": 100,
      "cpus": 4,
      "memory_mb": 16384
    }
  }' | jq

# Delete a node
curl -X DELETE http://<ironic-ip>:6385/v1/nodes/<node-uuid>
```

**2. Node Power Management**

```bash
# Get the current power state
curl -X GET http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states | jq

# Power on a node
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/power \
  -H "Content-Type: application/json" \
  -d '{"target": "power on"}' | jq

# Power off a node
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/power \
  -H "Content-Type: application/json" \
  -d '{"target": "power off"}' | jq

# Reboot a node
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/power \
  -H "Content-Type: application/json" \
  -d '{"target": "reboot"}' | jq
```

**3. Node Provisioning**

```bash
# Set node to available state (after cleaning)
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/provision \
  -H "Content-Type: application/json" \
  -d '{"target": "available"}'

# Deploy a node with an image
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/provision \
  -H "Content-Type: application/json" \
  -d '{
    "target": "active",
    "configdrive": {"user_data": "BASE64_ENCODED_USER_DATA_HERE"},
    "instance_info": {
      "image_source": "http://webserver/image.qcow2",
      "image_checksum": "md5sum_value_here",
      "root_gb": 20
    }
  }'

# Clean a node
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/provision \
  -H "Content-Type: application/json" \
  -d '{"target": "clean", "clean_steps": [{"interface": "deploy", "step": "erase_devices"}]}'
```

**4. Node Inspection**

```bash
# Trigger hardware inspection on a node
curl -X PUT \
  http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/provision \
  -H "Content-Type: application/json" \
  -d '{"target": "inspect"}'

# Get inspection data
curl -X GET http://<ironic-ip>:6385/v1/nodes/<node-uuid>/states/inventory | jq
```

**5. Ironic Image Management**

```bash
# List available images
curl -X GET http://<ironic-ip>:<vmediaTLSPort>/images | jq

# Upload a kernel image
curl -X PUT \
  http://<ironic-ip>:<vmediaTLSPort>/images/kernel-image \
  --data-binary @/path/to/kernel

# Upload an initramfs image
curl -X PUT \
  http://<ironic-ip>:<vmediaTLSPort>/images/initramfs-image \
  --data-binary @/path/to/initramfs
```

**Note:** When interacting with the Ironic API and enable_basicAuth is present then used flag -u with parameters ironicUsername:ironicPassword.

## Deploying Metal3 with this Helm Chart

### Prerequisites

- Kubernetes cluster with cert-manager installed
- LoadBalancer capability (e.g., MetalLB or cloud provider)
- Static IP address for Ironic services

### Basic Installation

```bash
helm repo add suse-edge https://suse-edge.github.io/charts
helm pull suse-edge/metal3 --untar
```

## Further Resources

- [Metal3 Website](https://metal3.io)
- [Metal3 User Guide](https://book.metal3.io)
- [Ironic Documentation](https://docs.openstack.org/ironic/latest/)
- [Redfish Specification](https://www.dmtf.org/standards/redfish)
