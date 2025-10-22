variable "name" {
  type        = string
  description = "Storage Integration name"
}

variable "allowed_locations" {
  type        = list(string)
  description = "Allowed S3 locations"
}

variable "aws_role_arn" {
  type        = string
  default     = null
  description = "AWS IAM Role ARN for the integration (optional, can be set after trust is established)"
}

variable "comment" {
  type    = string
  default = "Managed by Terraform"
}