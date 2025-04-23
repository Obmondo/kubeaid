# Basic Troubleshooting steps

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
