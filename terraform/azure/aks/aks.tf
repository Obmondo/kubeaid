data "azurerm_resource_group" "resource" {
  name     = var.resource_group
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                    = var.cluster_name
    location                = var.location
    resource_group_name     = var.resource_group
    dns_prefix              = var.dns_prefix
    kubernetes_version      = var.kubernetes_version
    private_cluster_enabled = var.private_cluster_enabled
    private_cluster_public_fqdn_enabled = true
    default_node_pool {
        name                = "agentpool"
        node_count          = var.agent_count
        vm_size             = var.vm_size
        enable_auto_scaling = var.enable_auto_scaling
        min_count           = var.min_node_count 
        max_count           = var.max_node_count
    }

    identity {
     type = "SystemAssigned"
    }
}

# This can be bit intimidating. We are using the bash since terraform right now doesn't support mixed type in json values
# https://github.com/hashicorp/terraform/issues/13991 https://github.com/hashicorp/terraform/issues/12256

data "external" "cluster_vnet_name" {
  program    = ["bash", "${path.module}/get_vnet_details.sh", "MC_${var.resource_group}_${var.cluster_name}_${var.location}", "name"]
  depends_on = [azurerm_kubernetes_cluster.k8s]
}

data "external" "cluster_vnet_id" {
  program    = ["bash", "${path.module}/get_vnet_details.sh", "MC_${var.resource_group}_${var.cluster_name}_${var.location}", "id"]
  depends_on = [azurerm_kubernetes_cluster.k8s]
}

