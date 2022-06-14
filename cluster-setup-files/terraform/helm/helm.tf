provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "argocd" {}
