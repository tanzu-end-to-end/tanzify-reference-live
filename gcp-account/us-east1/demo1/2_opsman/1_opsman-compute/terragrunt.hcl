
locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load opsman variables
  opsman_vars = read_terragrunt_config("opsman_vars.hcl")

  # Extract the variables we need for easy access
  opsman_build = local.opsman_vars.locals.opsman_build
  opsman_version = local.opsman_vars.locals.opsman_version

  region   = local.region_vars.locals.region
  availability_zones = local.region_vars.locals.availability_zones
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone
  project = local.environment_vars.locals.project
}

dependency "creds" {
  config_path = "../../0_secrets/secret-gcp-creds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    service_account_key = "fake"
  }
}

dependency "paving" {
  config_path = "../../1_infra/2_paving"
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

  source = "git::git@github.com:tanzu-end-to-end/tanzify-infrastructure.git//google/google-opsman-compute"

}

inputs = {
  region   = local.region
  environment_name = local.environment_name
  hosted_zone = local.hosted_zone
  project = local.project
  availability_zones = local.availability_zones

  opsman_build = local.opsman_build
  opsman_version = local.opsman_version

  service_account_key = dependency.creds.outputs.service_account_key
  ops_manager_ssh_public_key = dependency.paving.outputs.ops_manager_ssh_public_key
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  management_subnet_name = dependency.paving.outputs.management_subnet_name
  ops_manager_public_ip = dependency.paving.outputs.ops_manager_public_ip
  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
}