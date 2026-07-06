resource "azurerm_data_factory_linked_service_key_vault" "keyvault" {
  name            = "LS_KeyVault"
  data_factory_id = var.data_factory_id

  key_vault_id = var.key_vault_id
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls" {
  name            = "LS_ADLS_Bronze"
  data_factory_id = var.data_factory_id

  url = "https://${var.storage_account_name}.dfs.core.windows.net"

  use_managed_identity = true
}

resource "azurerm_data_factory_linked_service_azure_databricks" "databricks" {
  name            = "LS_Databricks_Dev"
  data_factory_id = var.data_factory_id

  adb_domain = var.databricks_workspace_url

  existing_cluster_id = var.cluster_id

  key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.keyvault.name
    secret_name         = "databricks-dev-token"
  }
}
