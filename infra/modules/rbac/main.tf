data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "account_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "eventgrid" {
  scope                = var.storage_account_id
  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "queue_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.principal_id

}

resource "azurerm_role_assignment" "vault_admin" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# resource "azurerm_role_assignment" "adf_kv_access" {
#   scope = module.keyvault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id = module.adf.principal_id
# }