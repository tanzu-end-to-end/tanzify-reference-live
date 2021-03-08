locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  location   = local.region_vars.locals.location
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone
  cloud_name = local.account_vars.locals.cloud_name
}

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
  config_path = "../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    resource_group_name = "fake"
  }
}


terraform {

  source = "git::https://github.com/tanzu-end-to-end/tanzify-infrastructure.git//azure/azure-harbor-pave"

}


inputs = {
  tenant_id =       dependency.creds.outputs.azure_tenant_id
  subscription_id = dependency.creds.outputs.azure_subscription_id
  client_id =       dependency.creds.outputs.azure_client_id
  client_secret =   dependency.creds.outputs.azure_client_secret
  resource_group_name = dependency.paving.outputs.resource_group_name
  location   = local.location
  environment_name = local.environment_name
  hosted_zone = local.hosted_zone
  cloud_name = local.cloud_name
}
