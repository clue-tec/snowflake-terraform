output "name" {
  value = snowflake_table.this.name
}

output "fully_qualified_name" {
  value = "${var.database}.${var.schema}.${var.name}"
}