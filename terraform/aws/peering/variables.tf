variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "location where the cluster needs to be created"
}

variable "acceptor_rt_table_ids" {
  type        = list
  description = "Requestor VPC private route tables IDs"
}

variable "acceptor_vpc_cidr" {
  type        = string
  description = "Acceptor VPC CIDR block"
}

variable "acceptor_vpc_id" {
  type        = string
  description = "Acceptor VPC ID"
}

variable "environment" {
  type        = string
  description = "Env of k8s cluster"
}

variable "cluster_name" {
  type        = string
  description = "K8s cluster name"
}
