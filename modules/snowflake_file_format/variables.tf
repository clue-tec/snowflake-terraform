variable "name" {
  type = string
}

variable "database" {
  type = string
}

variable "schema" {
  type = string
}

variable "format_type" {
  type = string
  # "CSV" | "JSON" 等（大文字推奨）
}

variable "compression" {
  type    = string
  default = null
}

variable "field_delimiter" {
  type    = string
  default = null
}

variable "skip_header" {
  type    = number
  default = null
}

variable "null_if" {
  type    = list(string)
  default = null
}

variable "strip_outer_array" {
  type    = bool
  default = null
}

variable "binary_format" {
  type    = string
  default = null
}

variable "time_format" {
  type    = string
  default = "AUTO"
}

variable "date_format" {
  type    = string
  default = "AUTO"
}

variable "timestamp_format" {
  type    = string
  default = "AUTO"
}

variable "encoding" {
  type    = string
  default = "UTF8"
}

variable "empty_field_as_null" {
  type    = bool
  default = null
}

variable "error_on_column_count_mismatch" {
  type    = bool
  default = null
}

variable "comment" {
  type    = string
  default = null
}