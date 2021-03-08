

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
  region   = local.region_vars.locals.region
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone

  subject_alternative_names = local.cert_vars.locals.subject_alternative_names
}

dependency "creds" {
  config_path = "../../0_secrets/secret-aws-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    service_account_key = "fake"
  }
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/tanzu-end-to-end/tanzify-infrastructure.git//aws/aws-acme-certs"
}



inputs  = {
  access_key =  dependency.creds.outputs.access_key
  secret_key =  dependency.creds.outputs.secret_access_token
  region = local.region
  environment_name = local.environment_name
  hosted_zone = local.hosted_zone
  subject_alternative_names = local.subject_alternative_names

  //acme_server_url = "https://acme-staging-v02.api.letsencrypt.org/directory" # Staging server used for testing
}

