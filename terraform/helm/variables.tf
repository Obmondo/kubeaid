variable "argocd_admin_bcrypt_password" {
  type        = string
  description = "Argocd admin password, in bcrypt format"
  sensitive   = true
}

variable "argocd_admin_password" {
  type        = string
  description = "Argocd admin password, in clear text format"
  sensitive   = true
}


variable "argocd_repos" {
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

variable "k8s_client_certificate" {
  type      = string
  sensitive = true
}

variable "k8s_client_key" {
  type      = string
  sensitive = true
}

variable "k8s_cluster_ca_certificate" {
  type      = string
  sensitive = true
}

variable "k8s_host" {
  type      = string
  sensitive = true
}

variable "restore_secrets" {
  type = bool
  default = false
}
