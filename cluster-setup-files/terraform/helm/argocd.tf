resource "helm_release" "argocd" {
  name             = "argo-cd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  namespace        = "argocd"
  version          = "3.29.5"
#  depends_on       = [
#    helm_release.sealed_secrets
#  ]

  set {
    name = "podAnnotations"
    value = "meta.helm.sh/release-name: argo-cd"
  }
}

#resource "argocd_repository" "argocd_repos" {
#  for_each        = var.argocd_repos
#  username        = "git"
#  ssh_private_key = file(each.value.ssh_private_key)
#  repo            = each.value.url
#  depends_on      = [
#    helm_release.argocd
#  ]
#}
