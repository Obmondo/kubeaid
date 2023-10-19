provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "clustertowg"
  resource_group_name       = var.ext_vnet_name != null ? var.ext_vnet_resource_group : var.resource_group
  virtual_network_name      = var.vnet_name != null ? var.vnet_name : var.ext_vnet_name
  remote_virtual_network_id = var.wg_vnet_id
  allow_forwarded_traffic   = var.allow_forwarded_traffic
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = var.peer_name
  resource_group_name       = var.wg_resource_group
  virtual_network_name      = var.wg_vnet_name
  remote_virtual_network_id = var.cluster_vnet_id != null ? var.cluster_vnet_id : var.ext_cluster_vnet_id
  allow_forwarded_traffic   = var.allow_forwarded_traffic
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_bastion_cluster" {
  name                  = "dnslink-wg-cluster"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = "MC_${var.resource_group}_${var.cluster_name}_${var.location}"
  virtual_network_id    = var.wg_vnet_id
}
