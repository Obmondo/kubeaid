provider "azurerm" {
  features {}
}

resource "azurerm_route_table" "routetable" {
  name                          = var.routetable_name
  location                      = var.location
  resource_group_name           = "MC_${var.resource_group}_${var.cluster_name}_${var.location}"
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.routes

    content {
      name  = route.value.routetable_route_name
      address_prefix  = route.value.address_prefix
      next_hop_type = route.value.next_hop_type
      next_hop_in_ip_address  = route.value.next_hop_in_ip_address
    }
  }
}
