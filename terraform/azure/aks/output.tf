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

output "host" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    sensitive = true
}

output "remote_virtual_network_id" {
    value = jsondecode(base64decode(data.external.cluster_vnet_id.result["base64_encoded"]))
}

output "virtual_network_name" {
    value = jsondecode(base64decode(data.external.cluster_vnet_name.result["base64_encoded"]))
}

output "private_dns_zone_name" {
    value = join(".", slice(split(".", azurerm_kubernetes_cluster.k8s.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.k8s.private_fqdn))))
}
