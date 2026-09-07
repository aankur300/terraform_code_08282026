terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-ankurbaghel"
    storage_account_name = "chc4a0ntas0002c"
    container_name       = "ojas"
    key                  = "ojas.tfstate"
  }
}

provider "azurerm" {
  features {}

}