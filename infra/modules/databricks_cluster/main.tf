terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.40"
    }
  }
}

resource "databricks_cluster" "this" {
  cluster_name = var.cluster_name
  spark_version = var.spark_version
  node_type_id = var.node_type_id
  autotermination_minutes = var.autotermination_minutes
  single_user_name = var.single_user_name

  num_workers = 0

  data_security_mode = "SINGLE_USER"

  spark_conf = {
    "spark.master" = "local[*, 4]"
    "spark.databricks.cluster.profile" = "singleNode"
  }

  custom_tags = {
    ResourceClass = "SingleNode"
  }
}
