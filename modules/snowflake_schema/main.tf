
resource "snowflake_schema" "this" {
  database = var.database
  name     = var.name

  comment                        = var.comment
  is_transient                   = var.is_transient
  data_retention_time_in_days    = var.data_retention_time_in_days
}
