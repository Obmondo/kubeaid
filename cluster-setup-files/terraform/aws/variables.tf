variable "master" {
  type = object({
    image_id     = string
    max_size     = number
    min_size     = number
    machine_type = string
  })
  description = "K8s master node spec"
  default = {
    image_id     = "099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-20220404"
    max_size     = 1
    min_size     = 1
    machine_type = "t4g.medium"
  }
}

variable "worker" {
  type = object({
    image_id     = string
    max_size     = number
    min_size     = number
    machine_type = string
  })
  description = "K8s worker nodes spec"
  default = {
    image_id     = "099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220404"
    max_size     = 2
    min_size     = 1
    machine_type = "t3.medium"
  }
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "location where the cluster needs to be created"
}

variable "domain_name" {
  type        = string
  description = "Domain Name of the k8s cluster"
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

variable "ingress_ips" {
  type    = list(string)
  default = ["10.0.0.100/32", "10.0.0.101/32"]
}

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

variable "kubernetes_version" {
  type        = string
  description = "K8s cluster version"
  default     = "1.22.8"
}

variable "tags" {
  type        = map
  description = "Tags for the k8s cluster"
  default     = ({})
}
