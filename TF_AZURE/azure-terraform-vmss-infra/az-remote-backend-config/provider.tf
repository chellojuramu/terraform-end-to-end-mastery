terraform {
  required_version = "~> 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.65.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-learndev-dev"
    storage_account_name = "tfstatelearndevdev"
    container_name       = "tfstate"
    key                  = "learndev/dev/bootstrap/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}