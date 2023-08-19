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

variable "routes" {
  type = map
  default = {}
}
