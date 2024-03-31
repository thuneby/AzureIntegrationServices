locals {
  workflow_name = "workflow1"
  schema        = file("${path.module}/cloudEventSpec.json")
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

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_logic_app_trigger_http_request" "workflow1_trigger" {
  name         = "workflow1-trigger"
  logic_app_id = azurerm_logic_app_workflow.workflow1.id
  schema       = <<SCHEMA
  ${local.schema}
  SCHEMA
}

resource "azurerm_eventgrid_system_topic_event_subscription" "fileuploaded_flow" {
  name                = "fileuploaded-workflow"
  system_topic        = azurerm_eventgrid_system_topic.fileupload.name
  resource_group_name = azurerm_resource_group.rg_shared_services.name
  webhook_endpoint {
    url = azurerm_logic_app_trigger_http_request.workflow1_trigger.callback_url
  }
  event_delivery_schema = "CloudEventSchemaV1_0"
  included_event_types  = ["Microsoft.Storage.BlobCreated"]

  depends_on = [
    azurerm_eventgrid_system_topic.fileupload,
    azurerm_logic_app_trigger_http_request.workflow1_trigger
  ]
}