

dependency "paving" {
  config_path = "../paving"
}

dependency "letsencrypt" {
  config_path = "../letsencrypt"
}

dependency "creds" {
  config_path = "../secret-azure-creds"
}


dependencies {
  paths = ["../opsman-compute", "../opsman-setup-scripts", "../opsman-install-configure"]
}

terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//tkgi-install-configure"

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
  ssl_certificate = dependency.letsencrypt.outputs.cert_full_chain
  ssl_private_key = dependency.letsencrypt.outputs.cert_private_key

  network_name = dependency.paving.outputs.network_name
  platform_vms_security_group_name = dependency.paving.outputs.platform_vms_security_group_name
  pks_as_name = dependency.paving.outputs.pks_as_name
  resource_group_name = dependency.paving.outputs.resource_group_name
  subscription_id = dependency.creds.outputs.azure_subscription_id
  tenant_id = dependency.creds.outputs.azure_tenant_id
  pks_master_managed_identity = dependency.paving.outputs.pks_master_managed_identity
  pks_worker_managed_identity = dependency.paving.outputs.pks_worker_managed_identity
  pks_dns = dependency.paving.outputs.pks_dns
  pks_lb_name = dependency.paving.outputs.pks_lb_name

}
