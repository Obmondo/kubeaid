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
    }

    identity {
     type = "SystemAssigned"
    }
}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  for_each              = var.nodepools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = each.value.vm_size
  node_count            = each.value.agent_count
  vnet_subnet_id        = azurerm_subnet.aks-default.id
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_node_count
  max_count             = each.value.max_node_count
  linux_os_config {
    sysctl_config {
      vm_max_map_count = each.value.max_map_count
    }
  }

  tags = {
    Environment = each.value.tags
  }
}
