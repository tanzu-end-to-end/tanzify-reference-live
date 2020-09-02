
include {
  path = find_in_parent_folders()
}

dependency "creds" {
  config_path = "../0_secrets/secret-gcp-creds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    service_account_key = "fake"
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

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//gcp/harbor-dns-lbs"
  extra_arguments "vars" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.tfvars",
      "${get_terragrunt_dir()}/../env.tfvars",
      "${get_terragrunt_dir()}/../../region.tfvars",
      "${get_terragrunt_dir()}/../../../_global/terraform.tfvars"
    ]
  }
}


inputs = {
  service_account_key = dependency.creds.outputs.service_account_key
  network_name = dependency.paving.outputs.network_name
}
