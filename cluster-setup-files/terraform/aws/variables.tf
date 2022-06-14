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

variable "bastion" {
  type = object({
    image_id     = string
    max_size     = number
    min_size     = number
    machine_type = string
  })
  description = "K8s master node spec"
  default = {
    image_id     = "099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220404"
    max_size     = 1
    min_size     = 1
    machine_type = "t2.micro"
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
  default     = "172.16.16.0/20"
}

variable "wg_server_port" {
  default     = 51820
  description = "Port for the vpn server."
}

variable "wg_persistent_keepalive" {
  default     = 25
  description = "Persistent Keepalive - useful for helping connection stability over NATs."
}

variable "wg_server_private_key" {
  type        = string
  default     = "UBvb1y0QmA/cwan0TdI5/gF4RaHbBfOZNRT4R0BPoWc="
  description = "WG server private key."
}

variable "wg_server_public_key" {
  type        = string
  default     = "+FjoIdKG3+MQdpvFI/rltaA6YElvVrybi3WdMEkktUs="
  description = "WG server private key."
}

variable "argocd_repo" {
  type        = object({
    k8id = object({
      url             = string,
      ssh_private_key = string,
    }),
    k8id-config = object({
      url             = string,
      ssh_private_key = string,
    })
  })
  description = "Git repo for K8id and respective owner git repo for data"
}
