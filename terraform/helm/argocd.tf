resource "random_string" "random" {
  length  = 32
}

resource "time_static" "mtime" {}

resource "sealedsecret_local" "argocd_repos" {
  name      = "argocd-secret"
  namespace = "argocd"
  data      = {
    "admin.password": var.argocd_admin_bcrypt_password
    "admin.passwordMtime": time_static.mtime.id
    "server.secretkey": random_string.random.result
  }
  depends_on = [
    random_string.random,
    time_static.mtime,
    helm_release.sealed-secrets
  ]
}

resource "kubectl_manifest" "argocd_secret" {
  yaml_body         = sealedsecret_local.argocd_repos.yaml_content
  force_new         = true
  server_side_apply = true
  wait              = true
}

resource "helm_release" "argocd" {
  name             = "argo-cd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  namespace        = "argocd"
  version          = "3.29.5"
  values           = [
    file("argocd.yaml")
  ]
  depends_on       = [
    kubectl_manifest.argocd_secret
  ]
}

resource "argocd_repository" "argocd_repos" {
  for_each        = var.argocd_repos
  ssh_private_key = file(each.value.ssh_private_key)
  repo            = each.value.url
  type            = "git"
  depends_on      = [
    helm_release.argocd
  ]
}
