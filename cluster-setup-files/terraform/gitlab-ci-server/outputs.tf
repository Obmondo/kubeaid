output "gitlab_vm_name" {
  value = local.gitlab_vm_name
}

output "gitlab_vm_id" {
  value = azurerm_linux_virtual_machine.vm-gitlab.id
}

output "gitlab_vm_ip_address" {
  value = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].ip_address : azurerm_network_interface.nic-gitlab.private_ip_address
}

output "gitlab_dns_name" {
  value = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].fqdn : null
}

output "gitlab_password" {
  value = random_password.gitlab-password
  sensitive = true
}

output "tls_private_key" {
  value = tls_private_key.ssh.public_key_openssh
}
