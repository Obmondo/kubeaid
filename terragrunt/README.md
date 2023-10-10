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
   yq (https://github.com/mikefarah/yq)
   ```

2. Git repository
   a. clone the k8id git repo from obmondo
   b. Create a fresh git repo (for better naming, we usually call it k8id-config)

### Setup AKS cluster on Azure

1. export your variables yaml file

    ```sh
     export OBMONDO_VARS_FILE=/path/to/yaml/values/file
    ```

    A sample variable yaml file looks like

    ```yaml
    location: "northeurope"
    resource_group: "obmondo"
    agent_count: 3
    dns_prefix: "k8s-qa"
    cluster_name: "abc"
    vm_size: "Standard_DS2_v2"
    kubernetes_version: "1.22.6"
    enable_auto_scaling: true
    min_node_count: 1
    max_node_count: 3
    vnet_name: "cluster_vnet"
    subnet_name: "cluster_subnet"
    vnet_address_space: "10.226.0.0/16"
    subnet_prefixes: "10.226.0.0/16"
    peer_name: "cluster-name_wg"
    private_cluster_enabled: true
    private_cluster_public_fqdn_enabled: true
    wg_resource_group: "obmondo-aks"
    wg_vnet_name: "obmondo-vnet"
    wg_vnet_id: "abcd"
    storage_account: "abc"
    container: "abcd"
    restore_secrets: false
    argocd_admin_password: "Testing@123"
    argocd_admin_bcrypt_password: $2a$10$KdHplv8yqG3pwtC3L.McZuzY3EJ74d0GB6lDs7dt9w8shrEQkhcQ.
    environment: "test"
    argocd_repos:
      k8id:
        url: "git@github.com:<org>/k8id.git"
        ssh_private_key: "/home/k8id"
      k8id-config:
        url: "git@github.com:<org>/k8id-config.git"
        ssh_private_key: "/home/k8id-config"
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
      terragrunt import 'azurerm_route.routes["172.20.249.0_wg"]' /subscriptions/bxxxxxxxxxxxx/resourceGroups/MC_k8s-prod-az1_prod/providers/Microsoft.Network/routeTables/aks-agentpool-routetable/routes/172.20.249.0_wg
      ```

   4. Verify the import

      ```sh
      # Example
      terraform state show azurerm_route.routes["172.20.249.0_wg"]
      ```
