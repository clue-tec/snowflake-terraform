
# Snowflake Terraform Template 

## ディレクトリ構成

```
snowflake-terraform/
  README.md
  envs/
    _common/config/           # 環境共通の設定
      buckets.yaml
      formats.yaml
    stg/                      # 環境別のterraformプロジェクト
      config/                 # 環境固有の設定
        integration.yaml
      provider.tf
      variables.tf
      main.tf                 # modules/stack を実行
    prd/
      config/
        integration.yaml
      provider.tf
      variables.tf
      main.tf
  modules/
    stack/                    # 他モジュールを実行するメインのモジュール
      main.tf
      variables.tf
    aws_snowflake_role/
    snowflake_storage_integration/
    snowflake_stage/
    snowflake_file_format/
    ・・・
```

## 実行環境

* Terraform v1.13.4

## プロジェクト構成

- **envs/<env>** は 環境別（stg, prd）に定義
- 各環境の **main.tf** は module 呼び出しのみ
- **modules/stack** に共通ロジックを集約

## 実行例
```powershell
# 環境変数の設定
#   AWS CLIの認証情報プロファイル名
$env:AWS_PROFILE = "your-profile"
#   Snowflake KeyPairの秘密鍵ファイル
$env:TF_VAR_private_key_pem = Get-Content -Raw "C:\path\to\snowflake_key.pem"
$env:TF_VAR_private_key_passphrase = 'passphrase'
# 環境別のディレクトリへ移動して実行
cd envs\stg
terraform init
terraform plan
terraform apply

cd envs\stg
terraform init
terraform plan
terraform apply
```

### ブログ記事

* [Terraform、Snowflakeでs3連携・テーブルを一括管理する](https://www.clue-tec.com/blog/snowflake_terraform/)
