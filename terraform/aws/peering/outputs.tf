output "peering_status" {
  value = [ for p in module.peerings : p.peering_status ]
}
