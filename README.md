
# Snowflake Terraform Template

## プロジェクト概要

* **S3 とのファイル連携**に必要な **Storage Integration / External Stage / File Format / Schema / Table** を Terraform で管理します。
* **Storage Integration は共通の IAM ロール**を使い、**バケット毎に Stage・Schema・Table を YAML 定義**から作成します。
* **stg / prd の2環境**で展開。ただし **スキーマ・ファイルフォーマット・テーブル定義は共通 YAML**として持ち、**各環境で必要な差分をオーバーライド**可能とします。

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

* envs/_commonに共通設定を配置し、環境別にenvs/stg, envs/prdの設定を配置することでDRYな環境にする。
* モジュールstack/main.tfで**YAML の探索パス**を `locals` で定義し、 `stack` から各モジュールを実行します。

## 実行環境

* Terraform v1.13.4

## YAMLでリソース構成を定義

- YAMLファイルは環境共通`envs/_common/config`と環境個別の`envs/{環境区分}/config` に定義します。
- **環境差分**は `envs/stg/config/*.yaml` に必要なキーだけ **上書き**できます。また、YAMLファイルの構造（キーと値）が同じであれば任意のファイル名で追加して分割定義することが可能です。
- YAML定義からS3バケット毎にIAMロールポリシー、外部ストレージ連携、外部ステージ、スキーマ、ソーステーブルを階層的に作成します。このようにすることで**バケット毎のスキーマにテーブルを配置する**ルールを強制することができます。
  - `envs/_common/config/buckets.yaml`の定義例
  - s3_bucketとstage_name, schemaは1対1の関係性を持つため、関連する名前を決めて定義するようにしてください。
  - テーブル数が多くなり管理対象が増える場合、バケット単位（`buckets_xxx.yaml`のようにファイル名は任意）を作成して分割してください。

```yaml
# バケット毎に以下のSnowflakeリソースを作成する
#   外部ステージ（バケット単位）
#   スキーマ（バケット単位）
#   ソーステーブル
buckets:
  - s3_bucket: s3://poc-clue-tec-com/
    stage_name: POC_STAGE
    schema: POC
    comment: "PoC用スキーマ"
    tables:
      - name: PRODUCT
        type: csv
        comment: "製品マスタ"
        columns:
          - { name: ID, type: NUMBER, comment: "主キー" }
          - { name: TEXT_DATA, type: VARCHAR, comment: "製品名" }

  - s3_bucket: s3://demo-clue-tec-com/
    stage_name: DEMO_STAGE
    schema: DEMO
    tables:
      - name: RAW_EVENTS
        type: json
        comment: "イベントJSON"
```

* フォーマット定義は、デフォルトで4種類を定義しており、`custom_file_formats`で追加が可能です。
  * `envs/_common/config/formats.yaml`の定義例

```
default_file_formats:
  CSV:
    format_type: CSV
    compression: NONE
    field_delimiter: ","
    skip_header: 1
    null_if: ["\N","NULL",""]
  CSV_GZ:
    format_type: CSV
    compression: GZIP
    field_delimiter: ","
    skip_header: 1
    null_if: ["\N","NULL",""]
  JSON:
    format_type: JSON
    compression: NONE
    strip_outer_array: true
    null_if: ["NULL"]
  JSON_GZ:
    format_type: JSON
    compression: GZIP
    strip_outer_array: true
    null_if: ["NULL"]

custom_file_formats: {}
```



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

