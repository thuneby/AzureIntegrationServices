locals {
  analytics_name = "integrations"
}

resource "azurecaf_name" "analytics-name" {
  name          = local.analytics_name
  resource_type = "azurerm_log_analytics_workspace"
  suffixes      = [var.env]
}

resource "azurerm_log_analytics_workspace" "analytics" {
  name                = azurecaf_name.analytics-name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  sku                 = var.analytics_sku
  retention_in_days   = 30
}