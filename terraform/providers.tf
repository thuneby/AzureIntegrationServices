terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.109.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.28"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.52.0"
    }
  }

  backend "azurerm" {
  }
}

# config in .tfbackend files
provider "azurerm" {
  features {}
}