locals {
  # Automatically load variables
  pivnet_vars = read_terragrunt_config("pivnet.hcl")

  pivnet-LastPassID =   local.pivnet_vars.locals.pivnet-LastPassID
}
generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "pivnet_token" {
    value = data.lastpass_secret.credentials.custom_fields.pivnet-token
  }

EOF
}


terraform {

  source = "git::https://github.com/tanzu-end-to-end/tanzify-infrastructure.git//secret-store/lastpass"

}

inputs = {
  credential-LastPassID = local.pivnet-LastPassID
}
