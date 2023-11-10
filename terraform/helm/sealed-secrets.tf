resource "helm_release" "sealed-secrets" {
  name             = "sealed-secrets"
  chart            = "sealed-secrets"
  repository       = "https://bitnami-labs.github.io/sealed-secrets"
  create_namespace = true
  namespace        = "system"
  values           = var.restore_secrets ? [file(var.secrets_file)] : null
  version          = "2.2.0"
}
