resource "azurerm_resource_group" "resourcegroup" {
    name     = var.resource_group
    location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = var.location
    resource_group_name = azurerm_resource_group.resourcegroup.name
    dns_prefix          = var.dns_prefix

    
    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = var.vm_size
    }

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    identity {
     type = "SystemAssigned"
    }


    tags = {
        Environment = "Development"
    }

    

}

output "kube_config" {
      value = azurerm_kubernetes_cluster.k8s.kube_config_raw
      sensitive = true
}
