variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group" {
  type = string
}

variable "agent_count" {
    default = 3
}

variable "dns_prefix" {
    default = "k8stest"
}

variable "cluster_name" {
    default = "k8stest"
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "vm_size" {
  type = string
}
