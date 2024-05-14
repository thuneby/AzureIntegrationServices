terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.103.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.28"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.49.1"
    }
  }

  backend "azurerm" {
  }
}

# config in .tfbackend files
provider "azurerm" {
  features {}
}