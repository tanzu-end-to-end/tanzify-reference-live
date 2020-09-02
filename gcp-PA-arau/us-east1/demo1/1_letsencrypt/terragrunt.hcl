

dependency "creds" {
  config_path = "../0_secrets/secret-gcp-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    service_account_key = "fake"
  }
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//gcp/acme-certs"
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

  service_account_key =  dependency.creds.outputs.service_account_key

}