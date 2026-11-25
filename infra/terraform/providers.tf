terraform {
  required_version = ">= 1.15.0, < 2.0.0"

  backend "azurerm" {
    resource_group_name  = "rg-threatshield-tfstate"
    storage_account_name = "stthreatshieldtfstate26"
    container_name       = "tfstate"
    key                  = "threatshield.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}