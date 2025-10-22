############################################
# YAML 読み込み & マージ（後方優先）
############################################
locals {
  yaml_files = flatten([
    for d in var.config_dir_list : [
      for f in fileset(d, "*.yaml") : "${d}/${f}"
    ]
  ])
  cfgs = [for p in local.yaml_files : yamldecode(file(p))]
  integration_cfgs      = [for c in local.cfgs : try(c.integration,         null) if try(c.integration,         null) != null]
  dff_cfgs              = [for c in local.cfgs : try(c.default_file_formats, {})]
  cff_cfgs              = [for c in local.cfgs : try(c.custom_file_formats,  {})]
  buckets_lists         = [for c in local.cfgs : try(c.buckets,              [])]
  integration           = merge({}, [for m in local.integration_cfgs      : m]...)
  default_file_formats  = merge({}, [for m in local.dff_cfgs              : m]...)
  custom_file_formats   = merge({}, [for m in local.cff_cfgs              : m]...)
  buckets               = flatten(local.buckets_lists)
  bucket_urls = distinct([for b in local.buckets : b.s3_bucket])
  s3_buckets  = [
    for u in local.bucket_urls :
    replace(element(split("/", replace(u, "s3://", "")), 0), "/", "")
  ]
}

############################################
# IAMロール（環境ごとに一つ）
############################################
module "aws_snowflake_role" {
  source = "../aws_snowflake_role"

  role_name = local.integration.role_name
  allowed_buckets = local.s3_buckets
  snowflake_iam_user_arn = local.integration.snowflake_iam_user_arn
  snowflake_external_id = local.integration.snowflake_external_id
}

############################################
# Storage Integration（環境ごとに一つ）
# Storage Integration を初回作成後、Snowflake側で aws_user_arn / external_id を取得
# その値を用いて AWS側のIAMロール（信頼ポリシーに external_id 条件・プリンシパルに aws_user_arn）を作成
############################################
module "storage_integration" {
  source = "../snowflake_storage_integration"

  aws_role_arn      = module.aws_snowflake_role.role_arn
  name              = local.integration.integration_name
  allowed_locations = local.bucket_urls
  comment           = "Managed by Terraform"
}

############################################
# Stage（S3バケット単位で作成）
############################################
module "stages" {
  source   = "../snowflake_stage"

  # buckets の stage_name をキーにする
  for_each = { for b in local.buckets : b.stage_name => b }

  name        = each.key
  database    = local.integration.admin_database
  schema      = local.integration.admin_schema
  url         = each.value.s3_bucket

  storage_integration_name = module.storage_integration.name

  comment = "Managed by Terraform"
}

############################################
# File Formats
############################################
module "file_formats" {
  source   = "../snowflake_file_format"

  for_each = merge(local.default_file_formats, local.custom_file_formats)
  name        = each.key
  database    = local.integration.admin_database
  schema      = local.integration.admin_schema
  format_type = upper(each.value.format_type)

  # CSV/JSON で使われうるオプション（存在すれば設定）
  compression     = try(each.value.compression, null)
  field_delimiter = try(each.value.field_delimiter, null)
  skip_header     = try(each.value.skip_header, null)
  null_if         = try(each.value.null_if, null)

  strip_outer_array = try(each.value.strip_outer_array, null)
  binary_format     = try(each.value.binary_format, null)
  time_format       = try(each.value.time_format, "AUTO")
  date_format       = try(each.value.date_format, "AUTO")
  timestamp_format  = try(each.value.timestamp_format, "AUTO")
  encoding          = try(each.value.encoding, "UTF8")
  empty_field_as_null               = try(each.value.empty_field_as_null, null)
  error_on_column_count_mismatch    = try(each.value.error_on_column_count_mismatch, null)

  comment = "Managed by Terraform"
}

############################################
# Schemas（各バケットの schema をユニークに作成）
############################################
module "schemas" {
  source   = "../snowflake_schema"

  for_each = {
    for b in local.buckets :
    b.schema => {
      database = local.integration.source_database
      name     = b.schema
      comment  = try(b.comment, null)
    }
  }
  database = each.value.database
  name     = each.value.name
  comment  = each.value.comment
}

############################################
# Tables
############################################
module "tables" {
  source   = "../snowflake_table"

  for_each = merge([
    for b in local.buckets : {
      for t in try(b.tables, []) :
      "${b.schema}.${t.name}" => {
        schema  = b.schema
        name    = t.name
        comment = try(t.comment, null)
        type    = try(t.type, "csv")
        columns = try(t.columns, [])
      }
    }
  ]...)
  database = local.integration.source_database
  schema   = each.value.schema
  name     = each.value.name
  type     = each.value.type
  columns  = each.value.columns
  comment  = each.value.comment
}