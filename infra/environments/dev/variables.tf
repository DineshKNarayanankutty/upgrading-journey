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

variable "single_user_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "spark_version" {
  type = string
}

variable "node_type_id" {
  type = string
}

variable "autotermination_minutes" {
  type = number
}