generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "pivnet_token" {
    value = var.tanzu_network_api_token
    sensitive = true
  }

EOF
}

terraform {
  source = pathexpand("../../../../../modules/tanzu-network-api-token")
}

inputs = {
  tanzu_network_api_token = "gMSvRRc4gmk2dsVFBh7q"
}
