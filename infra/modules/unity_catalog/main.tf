terraform {
  required_providers {
    databricks = {
        source = "databricks/databricks"
        version = "~> 1.4"
    }
  }
}

resource "databricks_storage_credential" "this" {
    name = var.name
    
    azure_managed_identity {
        access_connector_id = var.access_connector_id
    }

    comment = "Managed via Terraform"
}

resource "databricks_external_location" "bronze" {
  name = "ext-loc-bronze"
  url = "abfss://bronze@${var.storage_account_name}.dfs.core.windows.net/"

  credential_name = databricks_storage_credential.this.name

  comment = "Bronze Layer"
}

resource "databricks_external_location" "silver" {
    name = "ext-loc-silver"
    url = "abfss://silver@${var.storage_account_name}.dfs.core.windows.net/"

    credential_name = databricks_storage_credential.this.name

    comment = "Silver Layer"  
}

resource "databricks_external_location" "gold" {
    name = "ext-loc-gold"
    url = "abfss://gold@${var.storage_account_name}.dfs.core.windows.net/"

    credential_name = databricks_storage_credential.this.name

    comment = "Gold Layer"  
}