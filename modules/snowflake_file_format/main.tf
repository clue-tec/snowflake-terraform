resource "snowflake_file_format" "this" {
  name        = var.name
  database    = var.database
  schema      = var.schema
  format_type = var.format_type

  compression     = var.compression
  field_delimiter = var.field_delimiter
  skip_header     = var.skip_header
  null_if         = var.null_if

  strip_outer_array = var.strip_outer_array
  binary_format     = var.binary_format
  time_format       = var.time_format
  date_format       = var.date_format
  timestamp_format  = var.timestamp_format
  encoding          = var.encoding
  empty_field_as_null = var.empty_field_as_null
  error_on_column_count_mismatch = var.error_on_column_count_mismatch
  comment = var.comment
}
