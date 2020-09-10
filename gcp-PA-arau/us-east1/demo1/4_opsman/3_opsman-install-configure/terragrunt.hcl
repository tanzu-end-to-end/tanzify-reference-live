
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
  config_path = "../../2_paving"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    stable_config_opsmanager = "fake"
    stable_config_pas = "fake"
    stable_config_pks = "fake"

  }
}

dependencies {
  paths = ["../1_opsman-compute", "../2_opsman-setup-scripts"]
}

terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-install-configure"

}

inputs = {

  opsman_password = dependency.secret-opsman.outputs.opsman_password

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  opsman_configuration_values = jsonencode(merge(jsondecode(dependency.paving.outputs.stable_config_opsmanager),
                                                jsondecode(dependency.paving.outputs.stable_config_pas),
                                                jsondecode(dependency.paving.outputs.stable_config_pks)))

  ssl_cert = dependency.paving.outputs.ssl_certificate
  ssl_private_key = dependency.paving.outputs.ssl_private_key

}