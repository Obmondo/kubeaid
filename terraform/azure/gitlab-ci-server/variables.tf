variable "gitlab_vm_name" {
  type        = string
  description = "Name for the GitLab Virtual Machine"
}

variable "create_public_ip" {
  type        = bool
  default     = false
  description = "Create a public IP for the GitLab Virtual Machine"
}

variable "resource_group" {
  type        = string
  description = "Resource Group Name for GitLab resources"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network name for the GitLab Virtual Machine"
}

variable "vnet_address_space" {
  type        = string
  description = "Virtual Network Address space for the GitLab Virtual Machine"
}

variable "subnet_prefixes" {
  type        = string
  description = "Subnet prefixes for the GitLab Virtual Machine"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name for the GitLab Virtual Machine"
}

variable "vm_size" {
  type        = string
  description = "Azure Virtual Machine SKU for Gitlab Virtual Machine"
  default     = "Standard_DS2_v2"
}

variable "dns_label" {
  type        = string
  description = "DNS Name for the Public IP"
  default     = ""
}

variable "location" {
  type = string
}

variable "source_addresses" {
  type = list
}

variable "resource_group_name" {
  type = string
}