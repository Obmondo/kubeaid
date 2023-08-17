variable "routetable_name" {
  type    = string
  description = "Route Table Name"
}

variable "location" {
  type = string
  description = "Route Location"
}

variable "resource_group" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "disable_bgp_route_propagation" {
  type = bool
  default = false
}

variable "routes" {
  description = "List of route configurations"
  type = list(object({
    routetable_route_name   = string
    address_prefix       = string
    next_hop_type        = string
    next_hop_in_ip_address = string
  }))
}
