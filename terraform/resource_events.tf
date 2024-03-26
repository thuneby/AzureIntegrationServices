resource "azurerm_eventgrid_system_topic" "fileupload" {
  name                   = "fileupload-${var.env}"
  resource_group_name    = azurerm_resource_group.rg_shared_services.name
  location               = azurerm_resource_group.rg_shared_services.location
  topic_type             = "Microsoft.Storage.StorageAccounts"
  source_arm_resource_id = azurerm_storage_account.file_storage.id

  depends_on = [azurerm_storage_account.file_storage]
}



resource "azurerm_eventgrid_system_topic_event_subscription" "fileuploaded" {
  name                          = "fileuploaded-subscription"
  system_topic                  = azurerm_eventgrid_system_topic.fileupload.name
  resource_group_name           = azurerm_resource_group.rg_shared_services.name
  service_bus_queue_endpoint_id = azurerm_servicebus_queue.fileupload.id
  included_event_types          = ["Microsoft.Storage.BlobCreated"]

  depends_on = [
    azurerm_eventgrid_system_topic.fileupload,
    azurerm_servicebus_queue.fileupload
  ]
}