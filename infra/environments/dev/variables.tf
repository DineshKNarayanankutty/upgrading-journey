variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
}

variable "storage_account_name" {
  description = "Storage Account Name"
  type        = string
}

variable "databricks_workspace_name" {
  description = "Databricks Name"
  type        = string
}

variable "adf_name" {
  description = "Azure Data Factory Name"
  type        = string
}

variable "keyvault_name" {
  description = "Key Vault Name"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type = string
}

variable "databricks_cluster_id" {
  description = "Databricks Cluster ID"
  type = string
}
