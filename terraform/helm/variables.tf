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

variable "argocd_repos" {
  type = map
  default = {}
}

variable "repo_url"{
  type = string
  description = "URL to the repository (Git or Helm) that contains the application manifests."
  default = ""
}
variable "path"{
  type = string
  description = "Directory path within the repository. Only valid for applications sourced from Git."
  default = ""
}

variable "secrets_file" {
  type = string
  default = "allsealkeys.yml"
}
