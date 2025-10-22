output "name" {
  value = snowflake_storage_integration.this.name
}

# 以下2つは Snowflake 側が生成する値（AWSの信頼関係設定に必要）
# ご使用中の snowflake provider のバージョンによって属性名が異なる場合があります。
# 例: storage_aws_iam_user_arn / storage_aws_external_id
output "aws_user_arn" {
  value = snowflake_storage_integration.this.storage_aws_iam_user_arn
}

output "external_id" {
  value = snowflake_storage_integration.this.storage_aws_external_id
}
