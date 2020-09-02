
dependency "creds" {
  config_path = "../../0_secrets/secret-azure-creds"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    azure_subscription_id = "fake"
    azure_tenant_id = "fake"
    azure_client_id = "fake"
    azure_client_secret = "fake"
  }
}

dependency "paving" {
  config_path = "../../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    ops_manager_ssh_public_key = "fake"
    ops_manager_storage_account_name = "fake"
    ops_manager_container_name = "fake"
    ops_manager_dns = "fake"
    ops_manager_private_ip = "fake"
    resource_group_name = "fake"
    ops_manager_security_group_name = "fake"
    management_subnet_id = "fake"
  }
}

terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//azure/opsman/opsman-compute"
  extra_arguments "vars" {
    commands  = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.tfvars",
      "${get_terragrunt_dir()}/../../env.tfvars",
      "${get_terragrunt_dir()}/../../../region.tfvars",
      "${get_terragrunt_dir()}/../../../../_global/terraform.tfvars"
    ]
  }
}

inputs = {

  tenant_id =       dependency.creds.outputs.azure_tenant_id
  subscription_id = dependency.creds.outputs.azure_subscription_id
  client_id =       dependency.creds.outputs.azure_client_id
  client_secret =   dependency.creds.outputs.azure_client_secret

  ops_manager_ssh_public_key = dependency.paving.outputs.ops_manager_ssh_public_key
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  ops_manager_storage_account_name = dependency.paving.outputs.ops_manager_storage_account_name
  ops_manager_storage_container_name = dependency.paving.outputs.ops_manager_container_name
  ops_manager_dns = dependency.paving.outputs.ops_manager_dns

  ops_manager_private_ip = dependency.paving.outputs.ops_manager_private_ip
  resource_group_name = dependency.paving.outputs.resource_group_name
  ops_manager_security_group_name = dependency.paving.outputs.ops_manager_security_group_name
  subnet_id = dependency.paving.outputs.management_subnet_id


}