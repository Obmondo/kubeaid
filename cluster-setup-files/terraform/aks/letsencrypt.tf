resource "kubernetes_secret" "letsencrypt_cloudflare_api_token_secret" {
  metadata {
    name      = "letsencrypt-cloudflare-api-token-secret"
    namespace = kubernetes_namespace.cert_manager.metadata.0.name
  }

  data = {
    "api-token" = var.letsencrypt_cloudflare_api_token
  }
}


resource "kubernetes_manifest" "letsencrypt_issuer_staging" {
  manifest = yamldecode(templatefile(
    "${path.module}/letsencrypt-issuer.tpl.yaml",
    {
      "name"                      = "letsencrypt-staging"
      "email"                     = var.letsencrypt_email
      "server"                    = "https://acme-staging-v02.api.letsencrypt.org/directory"
      "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
      "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
    }
  ))

  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_manifest" "letsencrypt_issuer_production" {
  manifest = yamldecode(templatefile(
    "${path.module}/letsencrypt-issuer.tpl.yaml",
    {
      "name"                      = "letsencrypt-production"
      "email"                     = var.letsencrypt_email
      "server"                    = "https://acme-v02.api.letsencrypt.org/directory"
      "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
      "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
    }
  ))

  depends_on = [helm_release.cert_manager]
}
