locals {
  is_json = lower(var.type) == "json"

  normalized_columns = [
    for c in var.columns : {
      name     = c.name
      type     = upper(replace(c.type, "STRING", "VARCHAR"))
      nullable = try(c.nullable, null)
      comment  = try(c.comment,  null)
    }
  ]

  # JSONなら VARIANT 1列を合成、CSVなら渡された columns をそのまま使用

  effective_columns = local.is_json ? [
    {
      name = var.json_column_name
      type = "VARIANT"
    }
  ] : local.normalized_columns
}


resource "snowflake_table" "this" {
  database = var.database
  schema   = var.schema
  name     = var.name

  dynamic "column" {
    for_each = local.effective_columns
    content {
      name     = column.value.name
      type     = column.value.type
      nullable = try(column.value.nullable, null)
      comment  = try(column.value.comment,  null)
    }
  }

  comment = var.comment
}
