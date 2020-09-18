
locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access

  region   = local.region_vars.locals.region
  availability_zones = local.region_vars.locals.availability_zones
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone

}

dependency "creds" {
  config_path = "../../0_secrets/secret-aws-creds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    access_key =  "fake"
    secret_key =  "fake"
  }
}

dependency "paving" {
  config_path = "../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {

    network_name = "fake"
  }
}


terraform {
  source = "git::git@github.com:tanzu-end-to-end/tanzify-infrastructure.git//aws/aws-harbor-pave"
}


inputs = {
    region   = local.region
    environment_name = local.environment_name
    hosted_zone = local.hosted_zone
    access_key =  dependency.creds.outputs.access_key
    secret_key =  dependency.creds.outputs.secret_access_token
    vpc_id = dependency.paving.outputs.vpc_id
    public_subnet_ids = dependency.paving.outputs.public_subnet_ids
}

