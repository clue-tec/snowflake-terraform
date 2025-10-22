output "fully_qualified_name" {
  value = "${var.database}.${var.schema}.${snowflake_file_format.this.name}"
}
