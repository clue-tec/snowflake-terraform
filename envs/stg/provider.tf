terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket  = "clue-technologies-terraform-state"
    key     = "pj-poc/stg/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
    # profile = "your-aws-profile"  # 必要なら明示
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "snowflake" {
  organization_name      = var.organization_name
  account_name           = var.account_name
  user                   = var.user_name
  role                   = "sysadmin"
  warehouse              = var.warehouse

  authenticator          = "SNOWFLAKE_JWT"
  private_key            = var.private_key_pem
  private_key_passphrase = var.private_key_passphrase

  # レビュー機能を明示的に有効化
  preview_features_enabled = [
    "snowflake_storage_integration_resource",
    "snowflake_file_format_resource",
    "snowflake_stage_resource",
    "snowflake_table_resource"
  ]
}
