variable "environment" {
  type        = string
  description = "Env of k8s cluster"
}

variable "cluster_name" {
  type        = string
  description = "K8s cluster name"
}

variable "kops_state_bucket_name" {
  type        = string
  description = "K8s cluster name"
}
