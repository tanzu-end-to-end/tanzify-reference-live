locals {
  # Automatically load variables
  gcp_vars = read_terragrunt_config("gcp.hcl")

  gcp_service_account_LastPassID =   local.gcp_vars.locals.gcp_service_account_LastPassID
}

generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "service_account_key" {
    value = data.lastpass_secret.credentials.custom_fields.service-account-key
  }
EOF
}


terraform {

  source = "git::git@github.com:tanzu-end-to-end/tanzify-infrastructure.git//secret-store/lastpass"
}

inputs = {
  credential-LastPassID = local.gcp_service_account_LastPassID
}
