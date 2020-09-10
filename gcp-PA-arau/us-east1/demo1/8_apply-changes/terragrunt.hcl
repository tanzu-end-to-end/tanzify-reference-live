
dependency "paving" {
  config_path = "../2_paving"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
  }
}

dependencies {
  paths = ["../4_opsman/3_opsman-install-configure", "../5_harbor_install_configure"]
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-apply-changes"
}


inputs = {

    ops_manager_dns             = dependency.paving.outputs.ops_manager_dns
    ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
}
