terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.28"
    }
  }

  backend "local" {
  }
}

# config in .tfbackend files
provider "azurerm" {
  features {}
}