# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "myrules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefixes     = each.value.source_address_prefixes
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

# Create virtual network
resource "azurerm_virtual_network" "obmondo-vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create subnet
resource "azurerm_subnet" "obmondo-subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_prefixes]
}

resource "azurerm_public_ip" "pip-gitlab" {
  count               = var.create_public_ip ? 1 : 0
  name                = "pip-${local.gitlab_vm_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  domain_name_label   = length(var.dns_label) > 0 ? var.dns_label : local.gitlab_vm_name
}

resource "azurerm_network_interface" "nic-gitlab" {
  name                = "nic-${local.gitlab_vm_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = azurerm_subnet.obmondo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.pip-gitlab[0].id : null
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic-gitlab.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}
