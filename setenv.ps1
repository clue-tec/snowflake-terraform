
# 秘密鍵を環境変数へ
$env:TF_VAR_private_key_pem = Get-Content -Raw '.ssh\snowflake.p8'
$env:TF_VAR_private_key_passphrase = 'snowflake'
$env:AWS_PROFILE = 'mtd'
