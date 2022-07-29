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

variable "private_cluster_enabled" {
  type = bool
  default = false
  description = "Whether the cluster will be private or public"
}
