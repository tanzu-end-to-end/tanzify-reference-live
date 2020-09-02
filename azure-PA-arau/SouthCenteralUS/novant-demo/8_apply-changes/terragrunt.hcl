
dependency "paving" {
  config_path = "../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    tkgi_configuration_values = "fake"
  }
}

dependencies {
  paths = ["../3_opsman/opsman-install-configure", "../4_tkgi-install-configure", "../6_harbor-install-configure", "../7_tas-install-configure"]
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-apply-changes"

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

  ops_manager_dns             = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
}
