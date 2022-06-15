provider "aws" {
  region = var.region
}

provider "kops" {
  state_store = "s3://${var.kops_state_bucket_name}"
  aws {
    region = var.region
  }
}

provider "helm" {
  kubernetes {
    host                   = data.kops_kube_config.kube_config.server
    username               = data.kops_kube_config.kube_config.kube_user
    password               = data.kops_kube_config.kube_config.kube_password
    client_certificate     = data.kops_kube_config.kube_config.client_cert
    client_key             = data.kops_kube_config.kube_config.client_key
    cluster_ca_certificate = data.kops_kube_config.kube_config.ca_certs
  }
}
