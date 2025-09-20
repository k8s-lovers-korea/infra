terraform {
  backend "azurerm" {
    resource_group_name  = "clustergoose-project"
    storage_account_name = "clustergoose-tfstate"
    container_name       = "tfstate"
    key                  = "clustergoose/terraform.tfstate"
  }
}