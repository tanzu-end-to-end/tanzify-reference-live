
locals {

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load tkgi variables
  tkgi_vars = read_terragrunt_config("tkgi_vars.hcl")

  # Extract the variables we need for easy access
  iaas = local.account_vars.locals.iaas

  tkgi_tile_version = local.tkgi_vars.locals.tkgi_tile_version
  cluster_name = local.tkgi_vars.locals.cluster_name
  plan_name = local.tkgi_vars.locals.plan_name

}

dependency "paving" {
  config_path = "../../1_infra/2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    pks_api_dns_domain = "fake"
    stable_config_opsmanager = "{}"
    stable_config_pks = "{}"
  }

}



dependencies {
  paths = ["../../2_opsman/3_opsman-install-configure"]
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:tanzu-end-to-end/tanzify-infrastructure.git//tkgi-install-configure"

}


inputs = {

  iaas = local.iaas
  tkgi_tile_version = local.tkgi_tile_version
  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  tkgi_api_dns_domain = dependency.paving.outputs.pks_api_dns
  tkgi_configuration_values = jsonencode(merge(jsondecode(dependency.paving.outputs.stable_config_opsmanager),
                                              jsondecode(dependency.paving.outputs.stable_config_pks)))
  cluster_name = local.cluster_name
  plan_name = local.plan_name

}
