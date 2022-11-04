provider "vault" {
  address = "https://vault.teokyllc.internal:8200"
}

# This expects ARM_ACCESS_KEY env var is filled
terraform {
  backend "azurerm" {
    storage_account_name = "ataylorvaultbackend"
    container_name       = "tfstate"
    key                  = "vault.tfstate"
  }
}