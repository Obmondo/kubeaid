provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "clustertowg"
  resource_group_name       = "MC_${var.resource_group}_${var.cluster_name}_${var.location}"
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = var.wg_vnet_id
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "wgtocluster"
  resource_group_name       = var.wg_resource_group
  virtual_network_name      = var.wg_vnet_name
  remote_virtual_network_id = var.remote_virtual_network_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_bastion_cluster" {
  name                  = "dnslink-wg-cluster"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = "MC_${var.resource_group}_${var.cluster_name}_${var.location}"
  virtual_network_id    = var.wg_vnet_id
}
