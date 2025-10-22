variable "name" {
  type        = string
  description = "Stage name"
}

variable "database" {
  type        = string
  description = "Database where Stage resides"
}

variable "schema" {
  type        = string
  description = "Schema where Stage resides"
}

variable "url" {
  type        = string
  description = "S3 URL (e.g., s3://bucket/prefix/)"
}

variable "storage_integration_name" {
  type        = string
  description = "Snowflake Storage Integration name"
}

variable "comment" {
  type        = string
  default     = "Managed by Terraform"
}