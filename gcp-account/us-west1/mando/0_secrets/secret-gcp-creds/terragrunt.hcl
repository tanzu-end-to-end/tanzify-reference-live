generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "service_account_key" {
    value = data.local_file.keyfile.content
    sensitive = true
  }
EOF
}

terraform {
  source = pathexpand("../../../../../modules/gcp/keyfile")
}

inputs = {
  keyfile_path = pathexpand("~/.tf4k8s/gcp/terraform-fe-cphillipson-service-account-credentials.json")
}
