locals {
  # Automatically load variables
  opsman_secret_vars = read_terragrunt_config("opsman.hcl")

  opsman_password_LastPassID =   local.opsman_secret_vars.locals.opsman_password_LastPassID
}
generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  # This is a normal web password stored in lastpass
  output "opsman_password" {
    value = data.lastpass_secret.credentials.password
  }

EOF
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//secret-store/lastpass"
}

inputs = {
  credential-LastPassID = local.opsman_password_LastPassID
}
