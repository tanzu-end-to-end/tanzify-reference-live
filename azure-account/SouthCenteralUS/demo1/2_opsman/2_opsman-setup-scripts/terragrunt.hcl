
dependency "secret-pivnet" {
  config_path = "../../0_secrets/secret-pivnet-token"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    pivnet_token = "fake"
  }
}

dependency "secret-opsman" {
  config_path = "../../0_secrets/secret-opsman"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    opsman_password = "fake"
  }
}

dependency "paving" {
  config_path = "../../1_infra/2_paving"
  mock_outputs_allowed_terraform_commands = ["validate","plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
  }
}

dependencies {
  paths = ["../1_opsman-compute"]
}


terraform {

  source = "git::git@github.com:tanzu-end-to-end/tanzify-infrastructure.git//opsman/opsman-setup-scripts"

}

inputs = {

  opsman_password = dependency.secret-opsman.outputs.opsman_password
  pivnet_token = dependency.secret-pivnet.outputs.pivnet_token

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key

}