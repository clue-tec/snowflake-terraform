provider "aws" { region = var.aws_region }

# S3 アクセス許可（ロールにアタッチするポリシー）
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid     = "AllowS3Objects"
    actions = [
      "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject", "s3:DeleteObject", "s3:DeleteObjectVersion"
    ]
    resources = [for bucket in var.allowed_buckets : "arn:aws:s3:::${bucket}/*"]
  }

  statement {
    sid     = "AllowS3ListAndLocation"
    actions = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [for bucket in var.allowed_buckets : "arn:aws:s3:::${bucket}"]
  }
}

resource "aws_iam_policy" "s3_access" {
  name   = "snowflake_s3_access_policy"
  policy = data.aws_iam_policy_document.s3_access.json
}

# Snowflake の IAM ユーザーにのみ引受けを許す信頼ポリシー（ExternalId 条件付き）
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.snowflake_iam_user_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.snowflake_external_id]
    }
  }
}

resource "aws_iam_role" "snowflake_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.snowflake_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

output "role_arn" { value = aws_iam_role.snowflake_role.arn }
output "policy_arn" { value = aws_iam_policy.s3_access.arn }
