data "azurerm_virtual_network" "ext_vnet" {
  count = var.ext_vnet_name != null && var.ext_vnet_resource_group != null ? 1 : 0
  name                = var.ext_vnet_name
  resource_group_name = var.ext_vnet_resource_group
  provider = azurerm.currentsubs
}

provider "azurerm" {
  features {}
  alias = "currentsubs"
}

provider "azurerm" {
  features {}
  subscription_id = var.remote_subs_id
  alias = "remotewg"
  skip_provider_registration = true
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "clustertowg"
  resource_group_name       = var.ext_vnet_name != null ? var.ext_vnet_resource_group : var.resource_group
  virtual_network_name      = var.ext_vnet_name != null ? data.azurerm_virtual_network.ext_vnet[0].name : var.vnet_name
  remote_virtual_network_id = var.wg_vnet_id
  allow_forwarded_traffic   = var.allow_forwarded_traffic

  provider                  = azurerm.currentsubs
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = var.peer_name
  resource_group_name       = var.wg_resource_group
  virtual_network_name      = var.wg_vnet_name
  remote_virtual_network_id = var.cluster_vnet_id != null ? var.cluster_vnet_id : var.ext_cluster_vnet_id
  allow_forwarded_traffic   = var.allow_forwarded_traffic

  provider                  = azurerm.remotewg
}

# MC_xxx resource group is created by AKS automatically https://learn.microsoft.com/en-us/azure/aks/faq#why-are-two-resource-groups-created-with-aks

resource "azurerm_private_dns_zone_virtual_network_link" "link_bastion_cluster" {
  name                  = "dnslink-wg-cluster"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = "MC_${var.resource_group}_${var.cluster_name}_${var.location}"
  virtual_network_id    = var.wg_vnet_id

  provider              = azurerm.currentsubs
}
