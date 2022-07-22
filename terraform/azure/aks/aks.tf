data "azurerm_resource_group" "resource" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = var.location
    resource_group_name = var.resource_group
    dns_prefix          = var.dns_prefix
    kubernetes_version  = var.kubernetes_version

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
