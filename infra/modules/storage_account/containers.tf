resource "azurerm_storage_container" "containers" {
  for_each = toset(var.containers)

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}