terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.50.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-dev-rg"
    storage_account_name = "terradevtfstates"
    container_name       = "tfstates"
    key                  = "luna-dev/luna-dev.terraform.tfstate"
  }
  #   backend "remote" {
  #     organization = "Thinking-Dog" # org name from step 2.
  #     workspaces {
  #       name = "myTestTFstates" # name for your app's state.
  #     }
  #   }
  # }

}

provider "azurerm" {
  features {}
}