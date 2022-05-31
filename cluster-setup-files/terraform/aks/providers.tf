# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      version = ">= 2.75.0"
    }

    kubernetes = {
      version = ">= 1.22.6"
    }

   cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=3.9.1"
    }

    helm = {
      source  = "helm"
      version = ">=2.4.1"
    }
  }
}

# subscription_id will change based on which subscription VM will be added to
provider "azurerm" {
    features {}
}

provider "cloudflare" {
   api_token = var.letsencrypt_cloudflare_api_token
}

provider "helm" {
  kubernetes {
    host = azurerm_kubernetes_cluster.k8s.kube_config.0.host

    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.k8s.kube_config.0.host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}
