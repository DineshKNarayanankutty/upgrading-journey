terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "storage_account" {
  source = "../../modules/storage_account"

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  containers = ["bronze", "silver", "gold"]

  tags = var.tags
}

module "databricks_workspace" {
  source = "../../modules/databricks"

  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku = "premium"

  tags = var.tags
}