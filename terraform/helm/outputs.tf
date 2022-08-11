output "argocd_secret" {
  value = sealedsecret_local.argocd_repos.yaml_content
}
