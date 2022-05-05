data "azurerm_resource_group" "rg-gitlab" {
  name     = var.resource_group
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = var.location
    resource_group_name = var.resource_group
    dns_prefix          = var.dns_prefix
    kubernetes_version  = var.kubernetes_version

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = var.vm_size
    }

    identity {
     type = "SystemAssigned"
    }
}
