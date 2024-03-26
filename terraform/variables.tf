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



