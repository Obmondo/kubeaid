variable "location" {
  type    = string
  default = "eastus"
}

variable "wg_resource_group" {
  type = string
}

variable "wg_vnet_name" {
  type = string
  default = "wg_vnet"
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

variable "wg_vnet_cidr" {
  description = "CIDR for the Wireguard VNET"
  default = ["10.61.0.0/16"]
}

variable "wg_subnet_cidr" {
  description = "CIDR for the Wireguard Subnet"
  default = ["10.61.61.0/24"]
  
}

variable "wg_address" {
  type = string
}

variable "wg_peers" {
  type        = list(object({
    name        = string,
    public_key  = string,
    allowed_ips = string
  }))
  description = "List of client objects with IP and public key."
}

variable "public_iface" {
  type = string
}
