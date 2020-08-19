
generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "opsman_password" {
    value = data.lastpass_secret.credentials.password
  }

EOF
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//secret-store/lastpass"
  extra_arguments "vars" {
    commands  = get_terraform_commands_that_need_vars()

    required_var_files = ["${get_terragrunt_dir()}/terraform.tfvars"]

    optional_var_files = ["${get_terragrunt_dir()}/../env.tfvars"]
  }
}
