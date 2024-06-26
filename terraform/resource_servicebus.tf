locals {
  servicebus_name = "integrations-mycorp"
}

resource "azurecaf_name" "servicebus_name" {
  name          = local.servicebus_name
  resource_type = "azurerm_servicebus_namespace"
  suffixes      = [var.env]
  clean_input   = true
  #   random_length = 5
}

resource "azurerm_servicebus_namespace" "integrations" {
  name                = azurecaf_name.servicebus_name.result
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  location            = azurerm_resource_group.rg_shared_services.location
  sku                 = var.servicebus_sku
  capacity            = 0

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "integrations" {
  name         = "policy-integrations"
  namespace_id = azurerm_servicebus_namespace.integrations.id
  listen       = true
  send         = true
  manage       = false
}

resource "azurerm_servicebus_queue" "fileupload" {
  name         = "fileupload-${var.env}"
  namespace_id = azurerm_servicebus_namespace.integrations.id
}

