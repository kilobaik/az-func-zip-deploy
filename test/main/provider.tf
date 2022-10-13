terraform {
  # backend "azurerm" {
  #   tenant_id            = "0ae51e19-07c8-4e4b-bb6d-648ee58410f4"
  #   subscription_id      = "346b6362-f059-4ae6-8780-f1f497212a91"
  #   resource_group_name  = "test-rg-5"
  #   storage_account_name = "testrg5stac"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.19.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.27.0"
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

#provider "azuread" {
#}

provider "archive" {
}