
dependency "paving" {
  config_path = "../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    stable_config_opsmanager = "fake"
    stable_config_pas = "fake"
    stable_config_pks = "fake"

  }
}

dependency "harbor_pave" {
  config_path = "../3_harbor-pave"

  mock_outputs_allowed_terraform_commands = [
    "validate"]
  mock_outputs = {
    harbor_domain = "fake"
    harbor_web_lb_name = "fake"
  }
}

dependency "opsman"{
  config_path = "../4_opsman/3_opsman-install-configure"
}

terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//tile-install-configure"

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

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  tile_configuration_values = jsonencode(merge(jsondecode(dependency.paving.outputs.stable_config_opsmanager),
                                                jsondecode(dependency.paving.outputs.stable_config_pas),
                                                jsondecode(dependency.paving.outputs.stable_config_pks)))

  map_extratile_configuration = {
    "harbor_domain" = "${dependency.harbor_pave.outputs.harbor_domain}",
    "harbor_web_lb_name" = "${dependency.harbor_pave.outputs.harbor_web_lb_name}",
    "harbor_admin_password" = "VMware12"
  }
}

