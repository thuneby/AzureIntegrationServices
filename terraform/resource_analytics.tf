# locals {
#   analytics_name = "integrations"
# }

# resource "azurecaf_name" "rg-analytics-name" {
#   name          = "analytics"
#   resource_type = "azurerm_resource_group"
# }

# resource "azurerm_log_analytics_workspace" "analytics" {
#   name                = local.analytics_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg_shared_services.name
#   sku                 = var.analytics_sku
#   retention_in_days   = 30
# }