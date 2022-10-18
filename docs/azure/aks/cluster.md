# Setup Azure Kubernetes Managed cluster on Azure

## Prerequisite

   ```text
   az
   ```

## Setup

* Azure login

   ```sh
   az login
   ```

* Create a [values.yaml][./samples/values.yaml) and export the values.yaml file

    ```sh
     export OBMONDO_VARS_FILE=/path/to/yaml/values/file
    ```

* Setup wireguard instance for [vpn setup](../../../terraform/azure/wireguard/README.md) if you want one. This is optional

* Change your directory structure to the respective folder.
   For eg if you want to create the AKS cluster then you must be sitting at `terragrunt/aks` folder
   and run all the following commands from that folder

* For Azure terragrunt wants the storage account to be created before hand, so you will have run

   ```sh
   ./create-rg-sc-con.sh
   ```

* Now plan your terragrunt so that you can sure everything looks good to you

   ```sh
   terragrunt run-all plan
   ```

* Once you are happy with the above plan - go ahead and apply those

   ```sh
   terragrunt run-all apply
   ```

* Argocd Setup

  * Arogcd `root` app Setup [docs](../../../argocd-helm-charts/argo-cd/Readme.md/#setup-root-argocd-application)
  * Arogcd repo Setup [docs](../../../argocd-helm-charts/argo-cd/Readme.md/#add-argocd-repos)

### Connect to Kubernetes Cluster on Azure

```sh
# Setup account
az account set --subscription <subscription_id>

# Connect to cluster and merge the KUBECONFIG
az aks get-credentials --resource-group <resource_group> --name <cluster_name> --public-fqdn
```
