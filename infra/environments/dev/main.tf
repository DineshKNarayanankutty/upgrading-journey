terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.4"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = module.databricks_workspace.workspace_url
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

module "rbac" {
  source = "../../modules/rbac"

  storage_account_id = module.storage_account.id
  principal_id       = data.azurerm_databricks_access_connector.this.identity[0].principal_id
}

data "azurerm_databricks_access_connector" "this" {
  name                = "unity-catalog-access-connector"
  resource_group_name = "${var.databricks_workspace_name}-managed-rg"
}

module "unity_catalog" {
  source = "../../modules/unity_catalog"
  name   = "cred-sa-dev"

  access_connector_id = data.azurerm_databricks_access_connector.this.id

  storage_account_name = var.storage_account_name
}

resource "databricks_catalog" "this" {
  name = "learning"

  comment = "Main data catalog"

  storage_root = "abfss://gold@${var.storage_account_name}.dfs.core.windows.net/unity-catlog/learning/"
}

resource "databricks_schema" "bronze" {
  name         = "bronze"
  catalog_name = databricks_catalog.this.name
}

resource "databricks_schema" "silver" {
  name         = "silver"
  catalog_name = databricks_catalog.this.name
}

resource "databricks_schema" "gold" {
  name         = "gold"
  catalog_name = databricks_catalog.this.name
}

resource "random_string" "suffix" {
  length = 4
  upper = false
  special = false
}

module "adf" {
  source = "../../modules/adf"
  name = "${var.adf_name}-${random_string.suffix.result}"
  location = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_role_assignment" "adf_storage_access" {
  scope = module.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = module.adf.principal_id
}
