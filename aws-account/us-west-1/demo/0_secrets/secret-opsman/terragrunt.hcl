generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "opsman_password" {
    value = data.random_string.opsman_secret.result
    sensitive = true
  }

EOF
}

terraform {
  source = pathexpand("../../../../../modules/opsman-secret")
}
