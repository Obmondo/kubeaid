output "cluster_name" {
  value = kops_cluster.cluster.name
}

output "kube_config" {
  value     = data.kops_kube_config.kube_config
  sensitive = true
}
