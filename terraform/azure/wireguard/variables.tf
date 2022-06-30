variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "storage_account" {
  type = string
}

variable "storage_account_type" {
  type = string
  default = "Standard_LRS"
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "subscription_id" {
  type = string
  description = "subscription_id will change based on which subscription VM will be added to"
}

variable "domain" {
  type = string
}

variable "disks" {
  type = map
  default = {}
}

variable "tags" {
  type = map
  default = {}
}

variable "admin_account_passwordstore_path" {
  type = string
  description = "Path of the password store where Admin password is stored"
}

variable "wg_port" {
  default = 51820
}

variable "wg_client_pubkey" {
  type = string
}

variable "wg_address" {
  type = string
}

variable "wg_peer_address" {
  type = string
}

variable "public_iface" {
  type = string
}
