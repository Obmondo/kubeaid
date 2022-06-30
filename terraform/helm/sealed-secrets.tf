resource "helm_release" "sealed-secrets" {
  name             = "sealed-secrets"
  chart            = "sealed-secrets"
  repository       = "https://bitnami-labs.github.io/sealed-secrets"
  create_namespace = true
  namespace        = "system"
  version          = "2.2.0"
}
