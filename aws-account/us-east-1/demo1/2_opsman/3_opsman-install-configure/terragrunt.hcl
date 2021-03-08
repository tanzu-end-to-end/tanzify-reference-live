locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  # Extract the variables we need for easy access
  iaas = local.account_vars.locals.iaas
}

dependency "secret-opsman" {
  config_path = "../../0_secrets/secret-opsman"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    opsman_password = "fake"

  }
}

dependency "paving" {
  config_path = "../../1_infra/2_paving"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    ssl_certificate = "fake"
    ssl_private_key = "fake"
    stable_config_opsmanager = "{}"
    stable_config_pas = "{}"
    stable_config_pks = "{}"
  }

}

#Only needed if installing harbor. Remove this dependency block if not installing harbor
dependency "harbor-pave" {
  config_path = "../../1_infra/3_harbor-pave"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    harbor_domain = "fake"
    harbor_lb_security_group_name = "fake"
    harbor_lb_application_security_group_name = "fake"
    harbor_web_lb_name = "fake"
  }
}

dependencies {
  paths = ["../1_opsman-compute", "../2_opsman-setup-scripts"]
}

terraform {

  source = "git::https://github.com/tanzu-end-to-end/tanzify-infrastructure.git//opsman/opsman-install-configure"

}

inputs = {

  iaas = local.iaas
  opsman_password = dependency.secret-opsman.outputs.opsman_password

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  opsman_configuration_values = jsonencode(merge(jsondecode(dependency.paving.outputs.stable_config_opsmanager),
                                                jsondecode(dependency.paving.outputs.stable_config_pas),
                                                jsondecode(dependency.paving.outputs.stable_config_pks)))

  ssl_cert = dependency.paving.outputs.ssl_certificate
  ssl_private_key = dependency.paving.outputs.ssl_private_key

  # only needed if you are installing harbor. Remove this block if not installing harbor for aws
  map_extra_opsman_configuration_values = {
    "harbor_lb_security_group_id" = "${dependency.harbor-pave.outputs.harbor_lb_security_group_id}",
  }


}