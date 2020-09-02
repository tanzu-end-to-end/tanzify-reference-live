
dependency "creds" {
  config_path = "../../0_secrets/secret-gcp-creds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    service_account_key = "fake"
  }
}

dependency "paving" {
  config_path = "../../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_ssh_public_key = "fake"
    ops_manager_ssh_private_key = "fake"
    management_subnet_name = "fake"
    ops_manager_public_ip = "fake"
    ops_manager_dns = "fake"


  }
}

terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//gcp/opsman/opsman-compute"
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

  service_account_key = dependency.creds.outputs.service_account_key
  ops_manager_ssh_public_key = dependency.paving.outputs.ops_manager_ssh_public_key
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  management_subnet_name = dependency.paving.outputs.management_subnet_name
  ops_manager_public_ip = dependency.paving.outputs.ops_manager_public_ip
  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
}