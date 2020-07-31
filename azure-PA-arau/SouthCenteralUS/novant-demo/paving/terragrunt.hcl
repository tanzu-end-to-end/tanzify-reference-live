

dependency "creds" {
  config_path = "../lastpass"
}

generate "custom-output" {
  path = "custom-output.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

output "ops_manager.private_key_pem" {
  value = tls_private_key.ops_manager.private_key_pem
}

EOF
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:pivotal/paving.git//azure"

  extra_arguments "vars" {
    commands  = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.tfvars",
      "${get_terragrunt_dir()}/../env.tfvars",
      "${get_terragrunt_dir()}/../../region.tfvars",
      "${get_terragrunt_dir()}/../../../_global/terraform.tfvars"
    ]
  }
}


inputs = {
  subscription_id = dependency.creds.outputs.azure_subscription_id
  tenant_id = dependency.creds.outputs.azure_tenant_id
  client_id = dependency.creds.outputs.azure_client_id
  client_secret = dependency.creds.outputs.azure_client_secret
  hosted_zone = "novant-demo.azure.pcf-arau.pw"

}