terraform {
  required_version = ">= 1.15.0, < 2.0.0"

  backend "azurerm" {}        # <-- add this line

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
