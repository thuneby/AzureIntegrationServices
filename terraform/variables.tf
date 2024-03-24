variable "location" {
  type    = string
  default = "WestEurope"
}

variable "env" {
  type        = string
  description = "The environment. dev, test or prod."
}

