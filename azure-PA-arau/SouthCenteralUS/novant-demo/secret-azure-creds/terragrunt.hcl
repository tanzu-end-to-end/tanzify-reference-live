
generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "azure_subscription_id" {
    value = data.lastpass_secret.credentials.custom_fields.subscription_id
  }

  output "azure_client_id" {
    value = data.lastpass_secret.credentials.custom_fields.client_id
  }
  output "azure_client_secret" {
    value = data.lastpass_secret.credentials.custom_fields.client_secret
    sensitive = true
  }
  output "azure_tenant_id" {
    value = data.lastpass_secret.credentials.custom_fields.tenant_id
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
