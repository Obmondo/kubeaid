data "azurerm_resource_group" "resource" {
  name     = var.resource_group
}

# Create Virtual Network
resource "azurerm_virtual_network" "aksvnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = [var.vnet_address_space]
}

# Create a Subnet for AKS
resource "azurerm_subnet" "aks-default" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnet_prefixes]
}

# Create AKS cluster
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
        vnet_subnet_id      = azurerm_subnet.aks-default.id
        enable_auto_scaling = var.enable_auto_scaling
        min_count           = var.min_node_count 
        max_count           = var.max_node_count
        linux_os_config {
          sysctl_config {
            vm_max_map_count = var.max_map_count
          }
        }
    }

    identity {
     type = "SystemAssigned"
    }
}
