variable "location" {
  type    = string
  default = "WestEurope"
}

variable "env" {
  type        = string
  description = "The environment. dev, test or prod."
}

variable "servicebus_sku" {
  type        = string
  description = "SKU name for Azure Service Bus"
  nullable    = false
}

variable "apim_sku" {
  type        = string
  description = "SKU name for Azure API Management"
  nullable    = false
}

variable "key_vault_sku" {
  type        = string
  description = "SKU name for Azure Key Vault"
  nullable    = false
}

variable "analytics_sku" {
  type        = string
  description = "SKU name for Azure Application Insights"
  nullable    = false
}

variable "functions_plan_os" {
  type        = string
  description = "The OS type for the Azure Functions App Service Plan"
  nullable    = false
}

variable "functions_plan_sku" {
  type        = string
  description = "The SKU name for the Azure Functions App Service Plan"
  nullable    = false
}

variable "cosmos_troughput" {
  type        = number
  description = "The throughput for the Cosmos DB account"
  nullable    = false
}

variable "cosmos_free_tier" {
  type        = bool
  description = "Enable free tier for Cosmos DB account"
  default     = false
}



