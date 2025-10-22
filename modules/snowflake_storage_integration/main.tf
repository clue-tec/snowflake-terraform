resource "snowflake_storage_integration" "this" {
  name             = var.name
  type             = "EXTERNAL_STAGE"
  enabled          = true
  storage_provider = "S3"
  storage_allowed_locations = var.allowed_locations
  storage_aws_role_arn = var.aws_role_arn
  comment = var.comment
}