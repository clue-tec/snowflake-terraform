variable "aws_region" {
  type = string
  default = "ap-northeast-1"
}

variable "allowed_buckets" {
  type = list(string)
}

variable "snowflake_iam_user_arn" {
  type = string
  description = "IAMユーザーのARN。Snowflake 側の DESC INTEGRATION で取得"
}

variable "snowflake_external_id"  {
  type = string
  description = "外部ID。Snowflake 側の DESC INTEGRATION で取得"
}

# IAM ロール名
variable "role_name" {
  type = string
  default = "snowflake_s3_access_role"
}
