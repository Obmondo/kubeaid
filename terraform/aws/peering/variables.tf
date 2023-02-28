variable "cluster_name" {
  type        = string
  description = "K8s cluster name"
}

variable "peering_vpcs" {
  type        = set( string )
  default     = [ "wireguard" ]
  description = "Peerings between the cluster VPC and any other VPC's"
}
