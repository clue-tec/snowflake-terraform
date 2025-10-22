variable "database" {
  type = string
}

variable "schema" {
  type = string
}

variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "csv" # "csv" or "json"
}

variable "columns" {
  description = "For CSV: list of column definitions"
  type = list(object({
    name = string
    type = string
    nullable = optional(bool)
    comment  = optional(string) 
  }))
  default = []
}

variable "json_column_name" {
  type    = string
  default = "DATA"
}

variable "comment" {
  type    = string
  default = "Managed by Terraform"
}