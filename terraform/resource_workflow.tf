locals {
  workflow_name = "workflow1"
}

resource "azurecaf_name" "workflow_name" {
  name          = local.workflow_name
  resource_type = "azurerm_logic_app_workflow"
  suffixes      = [var.env]
  clean_input   = true
}

resource "azurerm_logic_app_workflow" "workflow1" {
  name                = local.workflow_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_shared_services.name
}

