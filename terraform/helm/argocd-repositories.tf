resource "argocd_application" "helm" {
  metadata {
    name      = "root"
    namespace = "argocd" 
    finalizers = ["resources-finalizer.argocd.argoproj.io"]   
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

    project = "default"

    source {
      repo_url = var.repo_url
      path     = var.path  
      target_revision = "HEAD" 
    }

    sync_policy {
      sync_options = ["ApplyOutOfSyncOnly=true"]
    }
  }
}

resource "argocd_repository" "private" {
  for_each        = var.argocd_repos
  name            = each.key
  repo            = var.url
  username        = var.username
  ssh_private_key = var.ssh_private_key

  depends_on      = [argocd_application.helm]
}