# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.97.1"
    }
    pass = {
      source = "camptocamp/pass"
    }
  }
}

# Subscription_id where wireguard VM will be created, it can be an external subscription ID also.
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
  skip_provider_registration = true
  alias = "externalsubs"
}

provider "azurerm" {
  features {}
}

provider "pass" {}

data "pass_password" "myterraformvm" {
  path = var.admin_account_passwordstore_path
}

data "azurerm_resource_group" "resource" {
  count = var.wg_resource_group == null ? 1 : 0

  name     = var.wg_resource_group
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "resourcegroup" {
  count = var.wg_resource_group != null ? 0 : 1

    name     = var.wg_resource_group
    location = var.location

  tags = var.tags
}

# Create virtual network
resource "azurerm_virtual_network" "wireguard_network" {
  name                = var.wg_vnet_name
  address_space       = var.wg_vnet_cidr
  location            = var.location
  resource_group_name = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name

  tags = {
    environment = "Terraform"
  }
}

# Create subnet
resource "azurerm_subnet" "wg_subnet" {
  name                 = "wg_subnet"
  resource_group_name  = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name
  virtual_network_name = azurerm_virtual_network.wireguard_network.name
  address_prefixes     = var.wg_subnet_cidr
}

# Create public IPs
resource "azurerm_public_ip" "wg_public_ip" {
  name                = "wg_public_ip"
  location            = var.location
  resource_group_name = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${upper(var.vm_name)}-00"
  location            = var.location
  resource_group_name = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name
  provider = azurerm.externalsubs
  ip_configuration {
    name            = "wireguard"
    subnet_id       = azurerm_subnet.wg_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.wg_public_ip.id
  }

  tags = var.tags
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = var.storage_account
  resource_group_name      = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name
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
  resource_group_name   = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  
  os_disk {
    name                 = "${upper(var.vm_name)}-OSdisk-00"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
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
      wg_port          = var.wg_port,
      wg_address       = var.wg_address,
      wg_peers         = var.wg_peers,
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
  resource_group_name  = var.wg_resource_group != null ? var.wg_resource_group : data.azurerm_resource_group.resource[0].name
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
