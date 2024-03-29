resource "azuread_application" "functions" {
  display_name = "functions-${var.env}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "functions" {
  client_id                    = azuread_application.functions.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "functions" {
  service_principal_id = azuread_service_principal.functions.object_id
  display_name         = "functions-${var.env}-client-secret"
}

resource "azurerm_key_vault_secret" "function_client_secret" {
  name         = "functions-${var.env}-client-secret"
  value        = azuread_service_principal_password.functions.value
  key_vault_id = azurerm_key_vault.integrations_keyvault.id
  content_type = "text/plain"

  depends_on = [
    azurerm_key_vault.integrations_keyvault,
    azuread_service_principal_password.functions
  ]
}