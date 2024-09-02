terraform {
  required_providers {
    argocd = {
      source = "oboukili/argocd"
      version = "6.1.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider kubernetes {
  config_path    = "~/.kube/config"
}

data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
  depends_on      = [helm_release.argocd]
}

provider "argocd" {

  username   = "admin"
  password   = lookup(data.kubernetes_secret.argocd_admin_password.data, "password", "")

  port_forward_with_namespace = "argocd"

  kubernetes {
    config_context = var.cluster_name
  }
}