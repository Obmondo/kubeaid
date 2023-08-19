provider "azurerm" {
  features {}
}

resource "azurerm_route" "routes" {
  for_each =  var.routes
  name                = each.key
  resource_group_name = "MC_${var.resource_group}_${var.cluster_name}_${var.location}"
  route_table_name    = var.routetable_name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}
