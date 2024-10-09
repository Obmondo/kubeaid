# Terragrunt

## Overview

* Configure your kubernetes cluster on Azure (AKS) and on AWS (Kops) for now (more cloud provider support are coming soon)
  with one single command.

  ```sh
  terragrunt run-all apply
  ```

* The cluster are private and terragrunt will setup a wireguard instance, which will be the only gateway i
  to access your kubernetes

## Prerequisite

1. Need this package to be installed on your local machine

   ```text
   kops
   kubectl
   jq
   terragrunt
   terraform
   bcrypt
   wireguard
   gopass
   yq (https://github.com/mikefarah/yq)
   ```

2. Git repository
   a. clone the kubeaid git repo from obmondo
   b. Create a fresh git repo (for better naming, we usually call it kubeaid-config)

### Setup AKS cluster on Azure

1. export your variables yaml file

    ```sh
     export OBMONDO_VARS_FILE=/path/to/yaml/values/file
    ```

    A sample variable yaml file looks like

    ```yaml
   location: "northeurope"
   resource_group: "k8s-shared-az1"
   agent_count: 4
   dns_prefix: "k8s-shared-az1"
   cluster_name: "az_cluster"
   vm_size: "Standard_E2s_v5"
   kubernetes_version: "1.29.2"
   enable_auto_scaling: true
   default_agent_count: 4
   min_node_count: 4
   max_node_count: 20
   storage_account: "k8saz"
   container: "k8sstatefile"
   private_cluster_enabled: true
   private_cluster_public_fqdn_enabled: true
   restore_secrets: false
   vnet_subnet_id: "/subscriptions/xxxxxxxxxxxxxxx/resourceGroups/alz-network-prod/providers/Microsoft.Network/virtualNetworks/vnetSpokeSharedProd/subnets/AKS-Cluster"
   ext_cluster_vnet_id: "/subscriptions/xxxxxxxxxxxxxxx/resourceGroups/alz-network-prod/providers/Microsoft.Network/virtualNetworks/vnetSpokeSharedProd"
   cluster_vnet_id: "/subscriptions/xxxxxxxxxxxxxxx/resourceGroups/alz-network-prod/providers/Microsoft.Network/virtualNetworks/vnetSpokeSharedProd"
   ext_vnet_name: "vnetProd"
   ext_vnet_resource_group: "alz-network-prod"
   remote_subs_id: "xxxxxxxxxxxxxxx"
   repo_url: "https://github.com/obmondo/kubeaid-config"
   path: "k8s/obmondo/argocd-apps"
   vnet_address_space: "10.250.0.0/16"
   subnet_prefixes: "10.250.128.0/18"
   peer_name: "az1_wg"
   wg_resource_group: "alz-network-hub"
   wg_vnet_name: "wg_vnet"
   wg_vnet_id: "/subscriptions/xxxxxxxxxxxxxxx/resourceGroups/alz-network-hub/providers/Microsoft.Network/virtualNetworks/wg_vnet"
   argocd_admin_password: "sdfdsfdsfs234353tf3e4sd12"
   argocd_admin_bcrypt_password: $2a$12$sdfdsfdsfs234353tf3e4sd12.tGewzImV5Hi05x7.9/3WbfS
   environment: "prod"
   argocd_repos:
     kubeaid:
       url: "git@github.com:obmondo/kubeaid.git"
       username: git
       ssh_private_key: "/Users/ubuntu/obmondo/kubeaid-config/keys/kubeaid.priv"
     kubeaid-config:
       url: "git@github.com:obmondo/kubeaid-config.git"
       username: git
       ssh_private_key: "/Users/ubuntu/obmondo/kubeaid-config/keys/kubeaid-config.priv"
   routetable_name: "aks-agentpool-3243434-routetable"
   routes:
     "10.10.210.0_wg":
       address_prefix: 10.10.200.0/24
       next_hop_type: VirtualAppliance
       next_hop_in_ip_address: 10.250.0.4
    ```

2. Change your directory structure to the respective folder.
   For eg if you want to create the AKS cluster then you must be sitting at `terragrunt/aks` folder
   and run all the following commands from that folder

3. For Azure terragrunt wants the storage account to be created before hand, so you will have run

   ```sh
   ./create-rg-sc-con.sh
   ```

4. Now plan your terragrunt so that you can sure everything looks good to you

   ```sh
   terragrunt run-all plan
   ```

5. Once you are happy with the above plan - go ahead and apply those

   ```sh
   terragrunt run-all apply
   ```

6. After your kube cluster is created - you will need to deploy the root application
   Assuming you have already created the `k8s/<clustername>/argocd-apps` in your kube config repo

   ```sh
   helm template k8s/<clustername>/argocd-apps --show-only templates/root.yaml | kubectl apply -f -
   ```

## Import existing resources into state file

   We import existing resources into state file so that we can manage them using terragrunt if something is changed manually.

   1. Backup the existing state file from the azure blob storage/s3 bucket.

   2. Check the statefile structure what is the resource type and name if there is any similar resource already created.

      ```sh
      terraform state list
      ```

   3. Run the following command to import the existing resources into state file.

      ```sh
      terragrunt <RESOURCE_TYPE>.<RESOURCE_NAME> <EXISTING_RESOURCE_ID>

      ```

      For example, if you want to import existing azure route into state file, run the following command.

      ```sh
      terragrunt import 'azurerm_route.routes["172.20.249.0_wg"]' /subscriptions/xxxxxxxxxxxx/resourceGroups/MC_k8s-prod-az1_prod/providers/Microsoft.Network/routeTables/aks-agentpool-routetable/routes/172.20.249.0_wg
      ```

   4. Verify the import

      ```sh
      # Example
      terraform state show azurerm_route.routes["172.20.249.0_wg"]
      ```

## Configuration Options

The following table lists the configurable parameters for the AKS cluster vars file.

Parameter                             | Description                                                                                     | Example
---                                   | ---                                                                                             | ---
`location`                            | Specifies the Azure region                                                                      | `northeurope`
`resource_group`                      | Specifies the resource group name                                                               | `k8s-az`
`agent_count`                         | Specifies the number of kubernetes agent nodes in custom node pool                              | `4`
`default_agent_count`                 | Specifies the number of kubernetes agent nodes in default node pool                             | `1`
`dns_prefix`                          | Specifies the DNS prefix for the AKS cluster                                                    | `k8s-az`
`cluster_name`                        | Specifies the name of the AKS cluster                                                           | `az_cluster`
`vm_size`                             | Specifies the size of the Virtual Machine                                                       | `Standard_E2s_v5`
`kubernetes_version`                  | Specifies the version of Kubernetes                                                             | `1.29.2`
`enable_auto_scaling`                 | Specifies whether the Auto Scaler is enabled or not                                             | `true`
`min_node_count`                      | Specifies the minimum number of nodes in the node pool                                          | `1`
`max_node_count`                      | Specifies the maximum number of nodes in the node pool                                          | `5`
`storage_account`                     | Specifies the storage account where the terragrunt statefile will store                         | `k8sazbucket`
`container`                           | Specifies the container name where the terragrunt statefile will store                          | `k8sstatefile`
`private_cluster_enabled`             | Specifies whether the AKS cluster is private or public                                          | `true`
`private_cluster_public_fqdn_enabled` | Specifies whether the AKS cluster has a public FQDN or not                                      | `true`
`vnet_name`                           | Specifies the name of the virtual network where the cluster will run                            | `vnetProd`
`subnet_name`                         | Specifies the name of the subnet where the cluster will run                                     | `AKS-Cluster`
`vnet_address_space`                  | Specifies the address space of the virtual network                                              | `10.226.0.0/16`
`peer_name`                           | Specifies the name of the wireguard peer                                                        | `az_wg`
`wg_resource_group`                   | Specifies the resource group name where the wireguard will be created                           | `alz-network-hub`
`wg_vnet_name`                        | Specifies the name of the virtual network where the wireguard will be created                   | `wg_vnet`
`wg_vnet_id`                          | Specifies the id of an existing wireguard virtual network . It will be used for peering from cluster to wireguard                                        | `/subscriptions/xxxxx/resourceGroups/obmondo/providers/Microsoft.Network/virtualNetworks/obmondo`
`argocd_admin_password`               | Specifies the argocd admin password                                                             | `sdfdsfdsf234234234`
`argocd_admin_bcrypt_password`        | Specifies the argocd admin bcrypt password                                                      | `$2a$12$sdfdsf2334234.tGewzImV5Hi05x7.9/3WbfS`
`environment`                         | Specifies the tag name of the cluster                                                                   | `prod`
