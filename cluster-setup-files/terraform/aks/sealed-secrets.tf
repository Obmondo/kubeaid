resource "helm_release" "sealed-secrets" {
  name             = "sealed-secrets"
  chart            = "sealed-secrets"
  repository       = "bitnami/sealed-secrets-controller"
  create_namespace = true
  namespace        = "system"
  version          = "v0.17.5"
}
