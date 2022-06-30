resource "azurerm_marketplace_agreement" "eula-gitlab" {
  publisher = "gitlabinc1586447921813"
  offer     = "gitlabee"
  plan      = "default"
}
