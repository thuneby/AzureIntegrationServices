locals {
  cosmos_account_name    = "integrations-mycorp"
  cosmos_db_name         = "integrations-${var.env}"
  product_container_name = "products"
  event_container_name   = "events"
}

resource "azurecaf_name" "cosmos_account_name" {
  name          = local.cosmos_account_name
  resource_type = "azurerm_cosmosdb_account"
  suffixes      = [var.env]
  clean_input   = true
  #   random_length = 5
}

resource "azurerm_cosmosdb_account" "integrations" {
  name                = azurecaf_name.cosmos_account_name.result
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  location            = azurerm_resource_group.rg_shared_services.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  free_tier_enabled   = var.cosmos_free_tier

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.rg_shared_services.location
    failover_priority = 0
  }

  capacity {
    total_throughput_limit = 1000
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = local.cosmos_db_name
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  account_name        = azurerm_cosmosdb_account.integrations.name
  throughput          = var.cosmos_troughput
}

resource "azurerm_cosmosdb_sql_container" "products" {
  name                  = local.product_container_name
  resource_group_name   = azurerm_resource_group.rg_shared_services.name
  account_name          = azurerm_cosmosdb_account.integrations.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths   = ["/id"]
  partition_key_version = 1
}

resource "azurerm_cosmosdb_sql_container" "events" {
  name                  = local.event_container_name
  resource_group_name   = azurerm_resource_group.rg_shared_services.name
  account_name          = azurerm_cosmosdb_account.integrations.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths   = ["/id"]
  partition_key_version = 1
}

resource "azurerm_key_vault_secret" "cosmos_connection_string" {
  name         = "cosmos-connection-string"
  value        = azurerm_cosmosdb_account.integrations.primary_sql_connection_string
  key_vault_id = azurerm_key_vault.integrations_keyvault.id
  content_type = "text/plain"

  depends_on = [
    azurerm_key_vault.integrations_keyvault,
    azurerm_cosmosdb_account.integrations
  ]
}