output "subzone_id" {
  value = aws_route53_zone.zone.id
}

output "availability_zone_names" {
  value = var.availability_zone_names
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "cidr" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "route_table_ids" {
  value = flatten([
    module.vpc.private_route_table_ids,
    module.vpc.public_route_table_ids,
  ])
}
