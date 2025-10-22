# 複数YAMLが入っているディレクトリのリスト（前方が共通、後方が環境差分） ---
variable "config_dir_list" {
  type        = list(string)
  description = "List of directories containing YAML configs (common then env-specific)"
}
