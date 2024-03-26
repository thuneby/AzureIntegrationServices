locals {
  plan_name = "functions"
}

resource "azurecaf_name" "plan_name" {
  name          = local.plan_name
  resource_type = "azurerm_app_service_plan"
  suffixes      = [var.env]
  clean_input   = true
}

resource "azurerm_service_plan" "functions_plan" {
  name                = azurecaf_name.plan_name.result
  location            = azurerm_resource_group.rg_shared_services.location
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  os_type             = var.functions_plan_os
  sku_name            = var.functions_plan_sku
}

resource "azurecaf_name" "fuctions-storage" {
  name          = "functionstorage"
  resource_type = "azurerm_storage_account"
  suffixes      = [var.env]
  clean_input   = true
  random_length = 5
}

resource "azurerm_storage_account" "functions" {
  name                     = azurecaf_name.fuctions-storage.result
  resource_group_name      = azurerm_resource_group.rg_shared_services.name
  location                 = azurerm_resource_group.rg_shared_services.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurecaf_name" "example_app" {
  name          = "exaple"
  resource_type = "azurerm_function_app"
  suffixes      = [var.env]
  clean_input   = true
  random_length = 5
}

resource "azurerm_linux_function_app" "example" {
  name                       = azurecaf_name.example_app.result
  resource_group_name        = azurerm_resource_group.rg_shared_services.name
  location                   = azurerm_resource_group.rg_shared_services.location
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key

  service_plan_id = azurerm_service_plan.functions_plan.id

  site_config {}

  depends_on = [
    azurerm_service_plan.functions_plan,
    azurerm_storage_account.functions
  ]
}