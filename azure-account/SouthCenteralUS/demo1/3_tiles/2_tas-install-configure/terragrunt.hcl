
locals {

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load tkgi variables
  tas4vms_vars = read_terragrunt_config("tas4vms_vars.hcl")

  # Extract the variables we need for easy access
  iaas = local.account_vars.locals.iaas

  tas4vms_tile_version = local.tas4vms_vars.locals.tas4vms_tile_version


}

dependency "paving" {
  config_path = "../../1_infra/2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    stable_config_opsmanager = "{}"
    stable_config_pas = "{}"
  }

}



dependencies {
  paths = ["../../2_opsman/3_opsman-install-configure", "../1_tkgi-install-configure"]
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//tas4vms-install-configure"

}


inputs = {
  iaas = local.iaas
  tas4vms_tile_version = local.tas4vms_tile_version
  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key

  tas4vms_configuration_values = jsonencode(merge(jsondecode(dependency.paving.outputs.stable_config_opsmanager),
  jsondecode(dependency.paving.outputs.stable_config_pas)))
}
