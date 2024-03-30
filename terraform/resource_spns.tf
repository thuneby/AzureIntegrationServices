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

resource "azurerm_role_assignment" "contributor" {
  name                 = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  description          = "Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries."
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.functions.object_id

  depends_on = [
    azuread_service_principal.functions
  ]
}

resource "azurerm_role_assignment" "rbac_admin" {
  name                 = "f58310d9-a9f6-439a-9e8d-f62e7b41a168"
  description          = "Manage access to Azure resources by assigning roles using Azure RBAC. This role does not allow you to manage access using other ways, such as Azure Policy."
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azuread_service_principal.functions.object_id

  depends_on = [
    azuread_service_principal.functions
  ]
}
