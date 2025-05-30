terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.30.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.28"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.4.0"
    }
  }

  backend "azurerm" {
  }
}

# config in .tfbackend files
provider "azurerm" {
  features {}
}