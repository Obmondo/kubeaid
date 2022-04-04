# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}


# subscription_id will change based on which subscription VM will be added to
provider "azurerm" {
    features {}
}
