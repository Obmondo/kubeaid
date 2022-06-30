variable "region" {
  type        = string
  description = "location where the cluster needs to be created"
}

variable "domain_name" {
  type        = string
  description = "Domain Name of the k8s cluster"
}

variable "wg_peers" {
  type        = list(object({
    name        = string,
    public_key  = string,
    allowed_ips = string
  }))
  description = "List of client objects with IP and public key. See Usage in README for details."
}

variable "wg_cidr" {
  type        = string
  description = "Wireguard CIDR for k8s cluster"
  default     = "172.16.16.1/20"
}

variable "wg_server_port" {
  default     = 51820
  description = "Port for the vpn server."
}

variable "subdomain" {
  type        = string
  description = "subdomain of the k8s cluster"
}

variable "admin_ssh_keys" {
  type        = list
  description = "Only one ssh key is supported as of now"
}
