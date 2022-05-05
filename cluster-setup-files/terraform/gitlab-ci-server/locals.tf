locals { 
  nsgrules = {
   
    ssh = {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefixes    = var.source_addresses
      destination_address_prefix = "*"
    }
    https = {
      name                       = "HTTPS"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefixes    = var.source_addresses
      destination_address_prefix = "*"
    }
  }
}
