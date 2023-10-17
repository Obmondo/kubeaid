output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}

output "client_key" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "k8s_fqdn" {
  value = "https://${azurerm_kubernetes_cluster.k8s.fqdn}"
}

output "private_fqdn" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  sensitive = true
}

output "private_dns_zone_name" {
  value = join(".", slice(split(".", azurerm_kubernetes_cluster.k8s.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.k8s.private_fqdn))))
}

output "cluster_vnet_id" {
  value = var.vnet_name != null ? azurerm_virtual_network.aksvnet[0].id : data.azurerm_virtual_network.ext_vnet[0].id
  sensitive = true
}

output "cluster_ext_vnet_id" {
  value = var.ext_vnet_name != null ? data.azurerm_virtual_network.ext_vnet[0].id : null
  sensitive = true
}
