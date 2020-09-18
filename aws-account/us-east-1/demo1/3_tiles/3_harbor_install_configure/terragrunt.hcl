
locals {

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load harbor variables
  harbor_vars = read_terragrunt_config("harbor_vars.hcl")

  # Extract the variables we need for easy access
  iaas = local.account_vars.locals.iaas

  tile_slug = local.harbor_vars.locals.tile_slug
  tile_version = local.harbor_vars.locals.tile_version

}

dependency "certs" {
  config_path = "../../1_infra/1_letsencrypt"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cert_ca = "fake"
  }
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

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    stable_config_opsmanager = "{}"
  }
}

dependency "harbor_pave" {
  config_path = "../../1_infra/3_harbor-pave"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    harbor_domain = "fake"
    harbor_web_lb_name = "fake"
  }

}

dependencies {
  paths = ["../../2_opsman/3_opsman-install-configure"]
}

terraform {

  source = "git::git@github.com:tanzu-end-to-end/tanzify-infrastructure.git//tile-install-configure"
}


inputs = {

  iaas = local.iaas

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key

  tile_slug = local.tile_slug
  tile_version = local.tile_version

  // Send in the paving config values as they are needed by the tile config
  tile_configuration_values = dependency.paving.outputs.stable_config_opsmanager


  // These are needed by the tile
  map_extratile_configuration = {
    "harbor_domain" = "${dependency.harbor_pave.outputs.harbor_domain}",
    "harbor_web_lb_name" = "${dependency.harbor_pave.outputs.harbor_web_lb_name}",
    "harbor_lb_security_group_id" = "${dependency.harbor_pave.outputs.harbor_lb_security_group_id}",
    "harbor_admin_password" = "${dependency.secret-opsman.outputs.opsman_password}",
    "tls_ca_cert" = "${dependency.certs.outputs.cert_ca}"
  }
}


