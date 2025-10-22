locals {
  config_dir_list = [
    "${path.module}/../_common/config",
    "${path.module}/config",
  ]
}

module "stack" {
  source = "../../modules/stack"
  config_dir_list = local.config_dir_list
}
