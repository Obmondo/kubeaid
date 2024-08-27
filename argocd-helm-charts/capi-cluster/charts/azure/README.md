# Helm Chart for Azure Managed Kubernetes Cluster

## Overview

This Helm chart deploys an Azure Managed Kubernetes Cluster using the Cluster API provider for Azure (CAPZ).
## Prerequisites

- Helm 3.0+
- Kubernetes 1.20+
- Azure CLI
- Cluster API (CAPI) and Cluster API Provider Azure (CAPZ) installed

## Installation

### Create an Azure Service Principal

```sh
az ad sp create-for-rbac --role Contributor --scopes="/subscriptions/${AZURE_SUBSCRIPTION_ID}" --sdk-auth > sp.json
```

### Create Kubernetes Secret for Azure Cluster Identity

```sh
kubectl create secret generic "${AZURE_CLUSTER_IDENTITY_SECRET_NAME}" --from-literal=clientSecret="${AZURE_CLIENT_SECRET}"
```
### Create Kubernetes Secret for controlplan

```sh
kubectl create secret generic "${CONTROL_NAME_JSON}" --from-file sp.json -n capz-system
```

### Create Kubernetes Secret for workernode

```sh
kubectl create secret generic "${WORKER_NAME_JSON}" --from-file sp.json -n capz-system
```

### Values Configuration

Before deploying the chart, update the `values.yaml` file with appropriate values for your environment.

### Example `values.yaml`

```yaml
global:
  clusterName: my-cluster
  kubernetes:
    version: "1.29.2"
  networkPolicy: azure
  networkPlugin: azure
  skuTier: Free
  clientSecret: mysecret
  clientID: 158ac5a8
  tenantID: 3964984e
  addonProfiles:
    - name: azureKeyvaultSecretsProvider
      enabled: true
    - name: azurepolicy
      enabled: true
  clusterNetwork:
    services:
      cidrBlocks: "192.168.0.0/16"
  virtualNetwork: 
    name: controlplan-vnet
    cidrBlock: "10.1.0.0/16"
    subnet:
      name: controlplan-subnet
      cidrBlock: "10.1.1.0/24"
managedCluster: false
selfManagedCluster:
  enabled: true
  clientSecret:
    ControlplanSecret: test-control-plane-azure-json
    workerNodeAzure: test-md-0-azure-json
    localHostname: '{{ ds.meta_data["local_hostname"] }}'
  apiLoadbalancer: Public

systemPool:
  osDiskSizeGB: 30
  sku: Standard_D2s_v3
  replicas: 1

userPool:
  osDiskSizeGB: 30
  sku: Standard_D2s_v3
  replicas: 1

location: centralindia
resourceGroupName: cluster-api
sshPublicKey: "ssh-rsa"
subscriptionID: cce2e9ac
additionalTags:
  environment: dev
```

### Deploying the Chart

```sh
helm install my-cluster ./path-to-helm-chart -f values.yaml
```

## Resources Created


## Customization

You can customize the chart by modifying the `values.yaml` file according to your requirements. Below are some of the customizable parameters:

- **global.clusterName**: Name of the cluster.
- **global.kubernetes.version**: Kubernetes version to use.
- **global.networkPolicy**: Network policy to use (`azure` or `calico`).
- **global.networkPlugin**: Network plugin to use (`azure` or `kubenet`).
- **global.skuTier**: SKU tier for the control plane (`Free` or `Standard`).
- **global.clientSecret**: Secret used for authentication.
- **global.clientID**: Client ID for the Service Principal.
- **global.tenantID**: Tenant ID for the Azure subscription.
- **global.addonProfiles**: Add-on profiles for the cluster.
- **global.clusterNetwork**: Cluster network configurations.
- **global.virtualNetwork**: Virtual network configurations.
- **systemPool**: System pool configurations.
- **userPool**: User pool configurations.
- **location**: Azure region where the resources will be deployed.
- **resourceGroupName**: Resource group name in Azure.
- **sshPublicKey**: SSH public key for accessing the nodes.
- **subscriptionID**: Azure subscription ID.
- **additionalTags**: Additional tags to be applied to the resources.

## License

This project is licensed under the Obmondo License.

## Support

