variable "location" {
  type    = string
  default = "WestEurope"
}

variable "env" {
  type        = string
  description = "The environment. dev, test or prod."
}

variable "apim_sku" {
  type    = string
  default = "Consumption_0"
}

variable "analytics_sku" {
  type    = string
  default = "PerGB2018"
}

variable "servicebus_sku" {
  type    = string
  default = "Basic"
}

variable "key_vault_sku" {
  type    = string
  default = "standard"
}

variable "app_configuration_sku" {
  type    = string
  default = "free"
}