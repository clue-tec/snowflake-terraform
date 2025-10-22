variable "organization_name" {
  type      = string
  default   = null
}

variable "account_name" {
  type      = string
  default   = null
}

variable "user_name" {
  type      = string
  default   = null
}

variable "warehouse" {
  type      = string
  default   = null
}

variable "private_key_pem" {
  type      = string
  sensitive = true
}

variable "private_key_passphrase" {
  type      = string
  sensitive = true
  default   = null
}

variable "config_dir_list" {
  type    = list(string)
  default = []
}
