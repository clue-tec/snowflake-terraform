output "name" {
  value = snowflake_stage.this.name
}

output "fully_qualified_name" {
  value = "${var.database}.${var.schema}.${var.name}"
}