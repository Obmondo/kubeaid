variable "location" {
  type    = string
  default = "northeurope"
  description = "location where the cluster needs to be created"
}

variable "resource_group" {
  type = string
  description = "Resource Group Name under which k8s cluster needs to be created"
}

variable "default_agent_count" {
  default = 1
  description = "The initial number of nodes in default node pool should exist in the Node Pool."
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

variable "vnet_name" {
  default = "aks-cluster"
  type = string
  description = "Virtual network name"
}

variable "private_subnet_name" {
  default = "aks-private-subnet"
  type = string
  description = "Private Subnet used for private endpoint"
}

variable "subnet_name" {
  default = "aks-default-subnet"
  type = string
  description = "Subnet name"
}

variable "vm_size" {
  type = string
  description = "Size of the VM"
}

variable "vnet_address_space" {
  type = string
  description = "The address space that is used for the virtual network"
}

variable "subnet_prefixes" {
  type = string
  description = "The address prefix to use for the subnet."
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
  default = null
  description = "The minimum number of nodes which should exist in the Node Pool. Valid only when auto scaling is enabled"
}

variable "max_node_count" {
  default = null
  description = "The maximum number of nodes which should exist in the Node Pool. Valid only when auto scaling is enabled"
}

variable "private_cluster_enabled" {
  type = bool
  default = false
  description = "Whether the cluster will be private or public"
}

variable "oidc_issuer_enabled" {
  default = false
  description = "Whether or not the OIDC feature is enabled or disabled"
}

variable "nodepools" {
  type = map
  default = {}
  }

variable "mode" {
  type = string
  default = "System"
  description = "Should the added Node Pool be used for System or User resources?"
}

variable "nodepool_name" {
  type = string
  default = "internal"
  description = "Name of the Node Pool"
}

variable "zones" {
  type    = set(string)
  default = []
  description = "Availability Zones"
}


variable "vm_max_map_count" {
  default = "262144"
  description = "Maximum number of memory map areas a process may have"
}

# auto_scaler_profile

variable "balance_similar_node_groups" {
  type = bool
  default = false
  description = "Should the autoscaler balance similar node groups?"
}

variable "expander" {
  type = string
  default = "random"
  description = "Which expander to use when scaling"
}

variable "empty_bulk_delete_max" {
  type = number
  default = 10
  description = "How many nodes can be deleted at once"
}

variable "max_graceful_termination_sec" {
  type = number
  default = 600
  description = "How long should the autoscaler wait for pods to terminate gracefully"
}

variable "new_pod_scale_up_delay" {
  type = string
  default = "0s"
  description = "How long should the autoscaler wait before scaling up"
}

variable "scale_down_delay_after_add" {
  type = string
  default = "10m"
  description = "How long should the autoscaler wait before scaling down after a node was added"
}

variable "scale_down_delay_after_delete" {
  type = string
  default = "10s"
  description = "How long should the autoscaler wait before scaling down after a node was deleted"
}

variable "scale_down_delay_after_failure" {
  type = string
  default = "3m"
  description = "How long should the autoscaler wait before scaling down after a node was deleted due to a failure"
}

variable "scale_down_unneeded" {
  type = string
  default = "10m"
  description = "How long should the autoscaler wait before scaling down unneeded nodes"
}

variable "scale_down_unready" {
  type = string
  default = "20m"
  description = "How long should the autoscaler wait before scaling down unready nodes"
}

variable "skip_nodes_with_local_storage" {
  type = bool
  default = false
  description = "Should the autoscaler skip nodes with local storage"
}

variable "scale_down_utilization_threshold" {
  type = string
  default = "0.5"
  description = "How much of the node's resources must be utilized before it is considered for scale down"
}

variable "scan_interval" {
  type = string
  default = "10s"
  description = "How often should the autoscaler scan for pods"
}

variable "sku_tier" {
  type = string
  description = "SKU Tier"
  default = "Standard"
}

variable "service_endpoints" {
  type        = list(string)
  description = "Service Endpoints"
  default     = []
}

# For using existing vnet and subnet 

variable "vnet_subnet_id" {
  description = "Resource ID of an existing subnet which you want your k8s cluster to use"
  type        = string
  default     = null
}

variable "ext_vnet_name" {
  description = "Name of the existing virtual network which you want your k8s cluster to use"
  type        = string
  default     = null
}

variable "ext_vnet_resource_group" {
  description = "Resource Group Name of the existing virtual network which you want your k8s cluster to use"
  type        = string
  default     = null
}

variable "environment" {
  description = "Name of environment"
  type        = string
  default     = "dev"
}


variable "backp_bucket_name" {
  type = string
  default = "420241backup"
}

variable "endpoint_subnet_prefixes" {
  type = string
  default = "10.250.0.0/24"
}

# Private endpoint

variable "private_dns_zone_ids" {
  description = "ID of the private dns zone"
  type = list(string)
  default     = null
}

variable "ext_dns_subscription_id" {
  description = "Subscription ID of the external account where DNS zone is created"
  type        = string
  default     = null
}
variable "ext_dns_subs_resource_group" {
  description = "Resource Group Name of the external account where DNS zone is created"
  type        = string
  default     = null 
}

variable "temporary_name_for_rotation" {
  description = "Temporary name for rotation"
  type        = string
  default     = "tempnodepool"
}

variable "cluster_backup_endpoint_resource_id" {
  description = "Resource ID of the cluster backup endpoint"
  type        = string
  default     = null 
}

variable "cluster_backup_endpoint_tenant_id" {
  description = "Tenant ID of the cluster backup endpoint"
  type        = string
  default     = null
  
}
