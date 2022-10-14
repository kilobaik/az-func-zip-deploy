terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.19.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "archive" {
}