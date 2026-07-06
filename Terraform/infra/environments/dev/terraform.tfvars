resource_group_name = "rg-learning-dev"
location            = "East US"

tags = {
  env     = "dev"
  owner   = "DKN"
  project = "databricks-learning"
}

storage_account_name = "sadatalakelearndkn"

databricks_workspace_name = "adb-learning-dev"

adf_name = "adf-learning-dev"

keyvault_name = "kv-learning-dev"

single_user_name = "dev"

cluster_name = "single-node-dev"

spark_version = "17.3.x-scala2.13"

node_type_id = "Standard_DC4as_v5"

autotermination_minutes = 30