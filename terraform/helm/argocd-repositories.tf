resource "argocd_application" "helm" {
  metadata {
    name      = "root"
    namespace = "argocd"
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
  repo            = each.value.url
  username        = each.value.username
  ssh_private_key = file(each.value.ssh_private_key)

  depends_on      = [argocd_application.helm]
}
