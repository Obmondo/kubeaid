terraform {
  required_providers {
    sealedsecret = {
      source = "Mobaibio/sealedsecret"
      version = "1.0.1"
    }

    argocd = {
      source = "oboukili/argocd"
      version = "3.2.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    client_certificate     = base64decode(var.k8s_client_certificate)
    client_key             = base64decode(var.k8s_client_key)
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  }
}

provider "sealedsecret" {
  controller_name      = "sealed-secrets"
  controller_namespace = "system"

  kubernetes {
    host                   = var.k8s_host
    client_certificate     = base64decode(var.k8s_client_certificate)
    client_key             = base64decode(var.k8s_client_key)
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  }
}

provider "random" {}

provider "time" {}

provider "argocd" {
  server_addr = "localhost:8080"
  username    = "admin"
  password    = var.argocd_admin_password

  port_forward                = true
  port_forward_with_namespace = "argocd"

  kubernetes {
    host                   = var.k8s_host
    client_certificate     = base64decode(var.k8s_client_certificate)
    client_key             = base64decode(var.k8s_client_key)
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = var.k8s_host
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  client_certificate     = base64decode(var.k8s_client_certificate)
  client_key             = base64decode(var.k8s_client_key)
}

provider "kubernetes" {
  host                   = var.k8s_host
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  client_certificate     = base64decode(var.k8s_client_certificate)
  client_key             = base64decode(var.k8s_client_key)
}
