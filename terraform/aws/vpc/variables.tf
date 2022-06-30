variable "region" {
  type        = string
  description = "location where the cluster needs to be created"
}

variable "cidr" {
  type        = string
  description = "CIDR for k8s cluster"
  default     = "10.0.0.0/16"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
}

variable "environment" {
  type        = string
  description = "Env of k8s cluster"
}

variable "cluster_name" {
  type        = string
  description = "K8s cluster name"
}

variable "domain_name" {
  type        = string
  description = "Domain Name of the k8s cluster"
}

variable "subdomain" {
  type        = string
  description = "subdomain of the k8s cluster"
}
