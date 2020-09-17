locals {
  # Automatically load variables
  aws_vars = read_terragrunt_config("aws.hcl")

  aws_service_account_LastPassID =   local.aws_vars.locals.aws_service_account_LastPassID
}

generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "access_key" {
    value = data.lastpass_secret.credentials.custom_fields.access_key
  }

output "secret_access_token" {
    value = data.lastpass_secret.credentials.custom_fields.secret_access_token
  }
EOF
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//secret-store/lastpass"
}
inputs = {
  credential-LastPassID = local.aws_service_account_LastPassID
}
