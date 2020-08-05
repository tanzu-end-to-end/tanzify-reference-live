
dependency "secret-azure" {
  config_path = "../secret-azure-creds"
}

dependency "secret-pivnet" {
  config_path = "../secret-pivnet-token"
}

dependency "paving" {
  config_path = "../paving"
}


dependency "letsencrypt" {
  config_path = "../letsencrypt"
}

dependencies {
  paths = ["../opsman-compute"]
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-install"

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

  tenant_id =       dependency.secret-azure.outputs.azure_tenant_id
  subscription_id = dependency.secret-azure.outputs.azure_subscription_id
  client_id =       dependency.secret-azure.outputs.azure_client_id
  client_secret =   dependency.secret-azure.outputs.azure_client_secret

  pivnet_token = dependency.secret-pivnet.outputs.pivnet_token

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key

  ssl_cert = dependency.letsencrypt.outputs.cert_full_chain
  ssl_private_key = dependency.letsencrypt.outputs.cert_private_key


}