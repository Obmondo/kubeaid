resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.19.4"
  namespace  = kubernetes_namespace.traefik.metadata.0.name

  set {
    name  = "ports.web.redirectTo"
    value = "websecure"
  }

  # Trust private AKS IP range
  set {
    name  = "additionalArguments"
    value = "{--entryPoints.websecure.forwardedHeaders.trustedIPs=10.0.0.0/16}"
  }
}

data "kubernetes_service" "traefik" {
  metadata {
    name      = helm_release.traefik.name
    namespace = helm_release.traefik.namespace
  }
}

resource "cloudflare_record" "traefik" {
  zone_id = var.cloudflare_zone_id
  name    = "k8s"
  type    = "A"
  value   = data.kubernetes_service.traefik.status.0.load_balancer.0.ingress.0.ip
  proxied = true
}
