data "azurerm_resource_group" "resource" {
  name     = var.resource_group
}

data "azurerm_virtual_network" "ext_vnet" {
  count = var.ext_vnet_name != null && var.ext_vnet_resource_group != null ? 1 : 0
  name                = var.ext_vnet_name
  resource_group_name = var.ext_vnet_resource_group

}

provider "azurerm" {
  subscription_id = var.ext_dns_subscription_id
  features {}
  alias = "externalsubs"
  skip_provider_registration = true
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
  depends_on = [ azurerm_virtual_network.aksvnet ]

  count = var.vnet_subnet_id == null ? 1 : 0

  name                 = var.subnet_name
  virtual_network_name = var.vnet_name != null ? var.vnet_name : data.azurerm_virtual_network.ext_vnet[0].name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnet_prefixes]
  service_endpoints    = var.service_endpoints
}

# Subnet for private endpoint
resource "azurerm_subnet" "endpoint-subnet" {
  depends_on = [ azurerm_virtual_network.aksvnet ]

  count = var.private_dns_zone_ids != null ? 1 : 0

  name                 = "private-endpoint-subnet"
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.endpoint_subnet_prefixes]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints = var.service_endpoints
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns" {
  depends_on = [ azurerm_subnet.endpoint-subnet ]
  count = var.private_dns_zone_ids != null ? 1 : 0

  name                  = "private-endpoint-link"
  resource_group_name   = var.ext_dns_subs_resource_group
  private_dns_zone_name = "privatelink.blob.core.windows.net"
  virtual_network_id    = var.ext_vnet_name != null && var.ext_vnet_resource_group != null ? data.azurerm_virtual_network.ext_vnet[0].id : azurerm_virtual_network.aksvnet.id
  registration_enabled = true
  provider = azurerm.externalsubs
}
# Create Private Endpoint for AKS storage account
resource "azurerm_private_endpoint" "storage_account" {
  count = var.private_dns_zone_ids != null ? 1 : 0

  name                = "StorageAccountEndpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.endpoint-subnet[count.index].id

  private_service_connection {
    name                           = "private-storage-blob"
    private_connection_resource_id = azurerm_storage_account.cluster_backup[count.index].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  
  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids =  var.private_dns_zone_ids
  }
}

resource "azurerm_storage_account" "cluster_backup" {
  count = var.private_dns_zone_ids != null ? 1 : 0

  name                     = "${var.backp_bucket_name}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    private_link_access {
        endpoint_resource_id = var.cluster_backup_endpoint_resource_id
        endpoint_tenant_id   = var.cluster_backup_endpoint_tenant_id
      }
  }
  
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
    azure_policy_enabled    = var.azure_policy_enabled
    default_node_pool {
        name                = var.nodepool_name
        node_count          = var.default_agent_count
        vm_size             = var.vm_size
        vnet_subnet_id      = var.vnet_subnet_id != null ? var.vnet_subnet_id : azurerm_subnet.aks-default[0].id
        enable_auto_scaling = var.enable_auto_scaling
        min_count           = var.min_node_count
        max_count           = var.max_node_count
        zones               = var.zones
        temporary_name_for_rotation = var.temporary_name_for_rotation
        orchestrator_version = var.kubernetes_version
      linux_os_config {
        sysctl_config {
          vm_max_map_count = var.vm_max_map_count
        }
      }
      tags = {
        Environment = var.environment
      }
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
      vm_max_map_count = var.vm_max_map_count
    }
  }

  tags = {
    Environment = each.value.environment
  }
}
