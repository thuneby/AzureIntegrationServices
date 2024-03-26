locals {
  apim_name       = "integrations-mycorp"
  publisher_name  = "TestCompany"
  publisher_email = "info@testcompany.com"
}

resource "azurecaf_name" "apim_name" {
  name          = local.apim_name
  resource_type = "azurerm_api_management"
  suffixes      = [var.env]
  clean_input   = true
}

resource "azurerm_api_management" "integration" {
  name                = azurecaf_name.apim_name.result
  location            = azurerm_resource_group.rg_shared_services.location
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  publisher_name      = local.publisher_name
  publisher_email     = local.publisher_email

  sku_name = var.apim_sku

  identity {
    type = "SystemAssigned"
  }
}

