# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    pass = {
      source = "camptocamp/pass"
    }
  }
}

# subscription_id will change based on which subscription VM will be added to
provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    skip_provider_registration = true
}

provider "pass" {}

data "pass_password" "myterraformvm" {
  path = var.admin_account_passwordstore_path
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "resourcegroup" {
    name     = var.resource_group
    location = var.location

  tags = var.tags
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${upper(var.vm_name)}-00"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name            = "GN"
    subnet_id       = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = var.storageaccount
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = upper(var.vm_name)
  location              = var.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "${upper(var.vm_name)}-OSdisk-00"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202201100"
  }

  computer_name  = "${var.vm_name}.${var.domain}"
  admin_username = "ubuntu"
  admin_password = data.pass_password.myterraformvm.path

  disable_password_authentication = false

  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  custom_data = base64encode(templatefile(
    "cloud_init.yml.tftpl",
    {
      wg_client_pubkey = var.wg_client_pubkey,
      wg_port          = var.wg_port,
      wg_address       = var.wg_address,
      wg_peer_address  = var.wg_peer_address,
      public_iface     = var.public_iface,
  }))

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "mydisk" {
  for_each             = var.disks
  name                 = "${upper(var.vm_name)}-datadisk-${each.key}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.size
}

resource "azurerm_virtual_machine_data_disk_attachment" "mydisk" {
  for_each           = var.disks
  managed_disk_id    = azurerm_managed_disk.mydisk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.myterraformvm.id
  lun                = each.value.lun
  caching            = "ReadWrite"
}

output "tls_private_key" {
  value = tls_private_key.example_ssh.public_key_openssh
}
