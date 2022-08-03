# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      version = ">= 2.75.0"
    }

    kubernetes = {
      version = ">= 1.22.6"
    }

    external = {
      version = ">=1.1.0"
    }
  }
}

# subscription_id will change based on which subscription VM will be added to
provider "azurerm" {
    features {}
}
