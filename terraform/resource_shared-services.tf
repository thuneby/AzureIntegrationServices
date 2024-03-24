locals {
  crname = "testcompany-integrations"
}

resource "azurecaf_name" "rg_shared_services_name" {
  name          = "integrations"
  resource_type = "azurerm_resource_group"
  clean_input   = true
}

resource "azurerm_resource_group" "rg_shared_services" {
  name     = azurecaf_name.rg_shared_services_name.result
  location = var.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# resource "azurecaf_name" "key_vault_name" {
#   name          = "integrations"
#   resource_type = "azurerm_key_vault"
#   clean_input   = true
#   random_length = 5
# }

# resource "azurerm_key_vault" "integrations_keyvault" {
#   name                        = azurecaf_name.key_vault_name.result
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   resource_group_name         = azurerm_resource_group.rg_shared_services.name
#   location                    = azurerm_resource_group.rg_shared_services.location
#   enabled_for_disk_encryption = true
#   sku_name                    = var.key_vault_sku

#   purge_protection_enabled   = false
#   soft_delete_retention_days = 7
#   enable_rbac_authorization  = true

#   network_acls {
#     default_action = "Allow"
#     bypass         = "AzureServices"
#   }

#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

# resource "azurerm_role_assignment" "key_vault_access_spn" {
#   role_definition_name = "Key Vault Secrets Officer"
#   scope                = azurerm_key_vault.integrations_keyvault.id
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "azurerm_role_assignment" "key_vault_cert_access_spn" {
#   role_definition_name = "Key Vault Certificates Officer"
#   scope                = azurerm_key_vault.integrations_keyvault.id
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "azurecaf_name" "container_registry_name" {
#   name          = local.crname
#   resource_type = "azurerm_container_registry"
#   clean_input   = true
# }

# resource "azurecaf_name" "app_configuration" {
#   name          = "integrations"
#   resource_type = "azurerm_app_configuration"
#   clean_input   = true
# }

# resource "azurerm_app_configuration" "integrations" {
#   name                = azurecaf_name.app_configuration.result
#   resource_group_name = azurerm_resource_group.rg_shared_services.name
#   location            = azurerm_resource_group.rg_shared_services.location
#   sku                 = var.app_configuration_sku
#   identity {
#     type = "SystemAssigned"
#   }

#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }

# }

# resource "azurerm_role_assignment" "app_configuration_data_owner" {
#   scope                = azurerm_app_configuration.integrations.id
#   role_definition_name = "App Configuration Data Owner"
#   principal_id         = data.azurerm_client_config.current.object_id
# }