generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "opsman_password" {
    value = var.opsman_secret
    sensitive = true
  }

EOF
}

terraform {
  source = pathexpand("../../../../../modules/opsman-secret")
}

inputs = {
  opsman_secret = "w2447qbzvuYBaZ3gj3aWRS"
}