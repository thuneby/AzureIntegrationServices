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

resource "azurecaf_name" "integration_fuctions_storage" {
  name          = "integratiionfuntions"
  resource_type = "azurerm_storage_account"
  suffixes      = [var.env]
  clean_input   = true
  random_length = 5
}

resource "azurerm_storage_account" "integration_functions" {
  name                     = azurecaf_name.integration_fuctions_storage.result
  resource_group_name      = azurerm_resource_group.rg_shared_services.name
  location                 = azurerm_resource_group.rg_shared_services.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurecaf_name" "integration_app" {
  name          = "integrations"
  resource_type = "azurerm_function_app"
  suffixes      = [var.env]
  clean_input   = true
  random_length = 5
}

resource "azurerm_windows_function_app" "integrations" {
  name                       = azurecaf_name.integration_app.result
  resource_group_name        = azurerm_resource_group.rg_shared_services.name
  location                   = azurerm_resource_group.rg_shared_services.location
  storage_account_name       = azurerm_storage_account.integration_functions.name
  storage_account_access_key = azurerm_storage_account.integration_functions.primary_access_key
  service_plan_id            = azurerm_service_plan.functions_plan.id

  site_config {}

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
    "ServiceBusConnection"     = "${azurerm_servicebus_namespace_authorization_rule.integrations.primary_connection_string}"
    "CosmosDBConnection"       = "${azurerm_cosmosdb_account.integrations.primary_sql_connection_string}"
    "CosmosDatabaseName"       = "${azurerm_cosmosdb_sql_database.main.name}"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags, site_config
    ]
  }

  depends_on = [
    azurerm_service_plan.functions_plan,
    azurerm_storage_account.integration_functions,
    azurerm_cosmosdb_sql_database.main,
    azurerm_cosmosdb_sql_container.events,
    azurerm_servicebus_queue.fileupload
  ]
}

resource "azurerm_role_assignment" "servicebus_integration_app" {
  scope                = azurerm_servicebus_queue.fileupload.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_windows_function_app.integrations.identity[0].principal_id

  depends_on = [
    azurerm_windows_function_app.integrations,
    azurerm_servicebus_queue.fileupload
  ]
}



resource "azurecaf_name" "api_fuctions_storage" {
  name          = "apifuntions"
  resource_type = "azurerm_storage_account"
  suffixes      = [var.env]
  clean_input   = true
  random_length = 5
}

resource "azurerm_storage_account" "api_functions" {
  name                     = azurecaf_name.api_fuctions_storage.result
  resource_group_name      = azurerm_resource_group.rg_shared_services.name
  location                 = azurerm_resource_group.rg_shared_services.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurecaf_name" "api_app" {
  name          = "api"
  resource_type = "azurerm_function_app"
  suffixes      = [var.env]
  clean_input   = true
  random_length = 5
}

resource "azurerm_windows_function_app" "apis" {
  name                       = azurecaf_name.api_app.result
  resource_group_name        = azurerm_resource_group.rg_shared_services.name
  location                   = azurerm_resource_group.rg_shared_services.location
  storage_account_name       = azurerm_storage_account.api_functions.name
  storage_account_access_key = azurerm_storage_account.api_functions.primary_access_key
  service_plan_id            = azurerm_service_plan.functions_plan.id

  site_config {}

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
    "CosmosDBConnection"       = "${azurerm_cosmosdb_account.integrations.primary_sql_connection_string}"
    "CosmosDatabaseName"       = "${azurerm_cosmosdb_sql_database.main.name}"
  }

  lifecycle {
    ignore_changes = [
      tags, site_config
    ]
  }

  depends_on = [
    azurerm_service_plan.functions_plan,
    azurerm_storage_account.api_functions,
    azurerm_cosmosdb_sql_database.main,
    azurerm_cosmosdb_sql_container.events
  ]
}

