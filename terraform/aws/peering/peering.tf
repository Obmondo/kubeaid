module "peerings" {
  for_each = var.peering_vpcs
  from_vpc = var.cluster_name
  to_vpc   = each.key
  source   = "./peerings/"
}
