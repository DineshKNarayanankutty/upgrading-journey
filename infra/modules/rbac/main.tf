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