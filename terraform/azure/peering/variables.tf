variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "peer_name" {
  type = string
  description = "Name of the peer between WG Vnet and AKS cluster Vnet"
}

variable "wg_vnet_name" {
  type = string
}

variable "wg_resource_group" {
  type = string
}

variable "wg_vnet_id" {
  type = string
}

variable "cluster_vnet_id" {
  type = string
}

variable "vnet_name" {
  default = null
  description = "Virtual network name"
}

variable "private_dns_zone_name" {
  type = string
}

variable "ext_vnet_name" {
  type = string
  default = null
}