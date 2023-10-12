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
  count = var.vnet_subnet_id == null ? 1 : 0

  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnet_prefixes]
  service_endpoints    = var.service_endpoints
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
    sku_tier                = var.sku_tier
    oidc_issuer_enabled     = var.oidc_issuer_enabled
    default_node_pool {
        name                = var.nodepool_name
        node_count          = var.default_agent_count
        vm_size             = var.vm_size
        vnet_subnet_id      = var.vnet_subnet_id != null ? var.vnet_subnet_id : azurerm_subnet.aks-default[0].id
        enable_auto_scaling = var.enable_auto_scaling
        min_count           = var.min_node_count
        max_count           = var.max_node_count
        zones               = var.zones
    }
    auto_scaler_profile {
        balance_similar_node_groups       = var.balance_similar_node_groups
        expander                          = var.expander
        empty_bulk_delete_max             = var.empty_bulk_delete_max
        max_graceful_termination_sec      = var.max_graceful_termination_sec
        new_pod_scale_up_delay            = var.new_pod_scale_up_delay
        scale_down_delay_after_add        = var.scale_down_delay_after_add
        scale_down_delay_after_delete     = var.scale_down_delay_after_delete
        scale_down_delay_after_failure    = var.scale_down_delay_after_failure
        scale_down_unneeded               = var.scale_down_unneeded
        scale_down_unready                = var.scale_down_unready
        skip_nodes_with_local_storage     = var.skip_nodes_with_local_storage
        scale_down_utilization_threshold  = var.scale_down_utilization_threshold
        scan_interval                     = var.scan_interval
    }
    identity {
     type = "SystemAssigned"
    }
}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  for_each              = var.nodepools
  name                  = each.key
  mode                  = var.mode
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = each.value.vm_size
  node_count            = each.value.agent_count
  vnet_subnet_id        = var.vnet_subnet_id != null ? var.vnet_subnet_id : azurerm_subnet.aks-default[0].id
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
