locals {


  # Automatically load harbor variables
  tile_vars = read_terragrunt_config("tile_vars.hcl")

  # Extract the variables we need for easy access
  product_names_to_apply  = local.tile_vars.locals.product_names_to_apply

}

  dependency "paving" {
  config_path = "../../1_infra/2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
  }

}

dependencies {
  paths = ["../3_harbor_install_configure"]
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::https://github.com/tanzu-end-to-end/tanzify-infrastructure.git//opsman/opsman-apply-changes"
}


inputs = {

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key

  product-names = local.product_names_to_apply
}
