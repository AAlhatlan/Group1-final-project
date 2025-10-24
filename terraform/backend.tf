terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-backend-rg-gr1"
    storage_account_name  = "aalhatlanstate001"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
