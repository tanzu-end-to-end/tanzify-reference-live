
dependency "secret-opsman" {
  config_path = "../../../../secret-opsman"
}

dependency "paving" {
  config_path = "../paving"
}


dependency "letsencrypt" {
  config_path = "../letsencrypt"
}

dependencies {
  paths = ["../opsman-compute", "../opsman-setup-scripts"]
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-install-configure"

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

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  opsman_configuration_values = dependency.paving.outputs.paving_config_yaml

  ssl_cert = dependency.letsencrypt.outputs.cert_full_chain
  ssl_private_key = dependency.letsencrypt.outputs.cert_private_key


}