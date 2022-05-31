variable "location" {
  type    = string
  default = "northeurope"
  description = "location where the cluster needs to be created"
}

variable "resource_group" {
  type = string
  description = "Resource Group Name under which k8s cluster needs to be created"
}

variable "agent_count" {
  default = 3
  description = "The initial number of nodes which should exist in the Node Pool."
}

variable "dns_prefix" {
  default = "k8stest"
  description = "DNS prefix specified when creating the managed cluster"
}

variable "cluster_name" {
  default = "k8stest"
  description = "Clsuter name"
}

variable "vm_size" {
  type = string
  description = "Size of the VM"
}

variable "kubernetes_version" {
  type = string
  description = "Kubernetes version which you want to install"
}

variable "enable_auto_scaling" {
  type = bool
  description = "Should the Kubernetes Auto Scaler be enabled for the Node Pool"
  default = false
}

variable "min_node_count" {
  default = 1
  description = "The minimum number of nodes which should exist in the Node Pool. Valid only when auto scaling is enabled"
}

variable "max_node_count" {
  default = 3
  description = "The maximum number of nodes which should exist in the Node Pool. Valid only when auto scaling is enabled"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email address that Let's Encrypt will use to send notifications about expiring certificates and account-related issues to."
  sensitive   = true
}

variable "letsencrypt_cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token with Zone-DNS-Edit and Zone-Zone-Read permissions, which is required for DNS01 challenge validation."
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type = string
  description = "Cloudflare Zone ID"
}
