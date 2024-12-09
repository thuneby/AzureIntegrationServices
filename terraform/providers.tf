terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.28"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
  }

  backend "azurerm" {
  }
}

# config in .tfbackend files
provider "azurerm" {
  features {}
}