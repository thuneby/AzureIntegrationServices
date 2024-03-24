locals {
  crname = "testcompany-integrations"
}

resource "azurecaf_name" "rg_shared_services_name" {
  name          = "integrations"
  resource_type = "azurerm_resource_group"
  suffixes      = [var.env]
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
#   suffixes      = [var.env]
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


