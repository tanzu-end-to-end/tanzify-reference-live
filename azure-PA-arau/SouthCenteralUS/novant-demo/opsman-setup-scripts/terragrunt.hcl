
dependency "secret-pivnet" {
  config_path = "../../../../secret-pivnet-token"
}

dependency "secret-opsman" {
  config_path = "../../../../secret-opsman"
}

dependency "paving" {
  config_path = "../paving"
}

dependencies {
  paths = ["../opsman-compute"]
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-setup-scripts"

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

  opsman_password = dependency.secret-opsman.outputs.opsman_password
  pivnet_token = dependency.secret-pivnet.outputs.pivnet_token

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key

}