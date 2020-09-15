locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load cert variables
  cert_vars = read_terragrunt_config("cert_vars.hcl")

  # Extract the variables we need for easy access

  location   = local.region_vars.locals.location
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone
  cloud_name = local.account_vars.locals.cloud_name
  subject_alternative_names = local.cert_vars.locals.subject_alternative_names
}


dependency "creds" {
  config_path = "../../0_secrets/secret-azure-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    azure_subscription_id = "fake"
    azure_tenant_id = "fake"
    azure_client_id = "fake"
    azure_client_secret = "fake"
  }
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//azure/azure-acme-certs"
}

inputs = {


  tenant_id =       dependency.creds.outputs.azure_tenant_id
  subscription_id = dependency.creds.outputs.azure_subscription_id
  client_id =       dependency.creds.outputs.azure_client_id
  client_secret =   dependency.creds.outputs.azure_client_secret
  hosted_zone = local.hosted_zone
  location = local.location
  hosted_zone = local.hosted_zone
  environment_name = local.environment_name
  cloud_name = local.cloud_name
  subject_alternative_names = local.subject_alternative_names


}