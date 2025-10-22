variable "database" {
  type = string
}

variable "name" {
  type = string
}

# 任意オプション（必要に応じて利用）
variable "comment" {
  type    = string
  default = null
}

variable "is_transient" {
  type    = bool
  default = false
}

variable "data_retention_time_in_days" {
  type    = number
  default = null
}
