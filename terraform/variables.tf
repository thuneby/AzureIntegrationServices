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

