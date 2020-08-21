

dependency "creds" {
  config_path = "../0_secrets/secret-azure-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    azure_subscription_id = "fake"
    azure_tenant_id = "fake"
    azure_client_id = "fake"
    azure_client_secret = "fake"
  }
}

dependency "certs" {
  config_path = "../1_letsencrypt"
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    cert_full_chain = "fake"
    cert_private_key = "fake"
  }
}


terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:pivotal/paving.git//azure"
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
  subscription_id = dependency.creds.outputs.azure_subscription_id
  tenant_id = dependency.creds.outputs.azure_tenant_id
  client_id = dependency.creds.outputs.azure_client_id
  client_secret = dependency.creds.outputs.azure_client_secret
  ssl_certificate = dependency.certs.outputs.cert_full_chain
  ssl_private_key = dependency.certs.outputs.cert_private_key
  hosted_zone = "novant-demo.azure.pcf-arau.pw"

}

generate "custom-output" {
  path = "custom-output.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

output "network_name" { value = local.stable_config.network_name }

output "resource_group_name" { value = local.stable_config.resource_group_name }

output "management_subnet_name" { value = local.stable_config.management_subnet_name}
output "management_subnet_id" { value   = local.stable_config.management_subnet_id}
output "management_subnet_cidr" { value = local.stable_config.management_subnet_cidr}
output "management_subnet_gateway" { value = local.stable_config.management_subnet_gateway}
output "management_subnet_range" { value = local.stable_config.management_subnet_range}

output "bosh_storage_account_name" { value  = local.stable_config.bosh_storage_account_name}

output "ops_manager_security_group_name" { value   = local.stable_config.ops_manager_security_group_name}
output "ops_manager_ssh_private_key" { value = local.stable_config.ops_manager_ssh_private_key}
output "ops_manager_ssh_public_key" { value =  local.stable_config.ops_manager_ssh_public_key}
output "ops_manager_private_ip" { value = local.stable_config.ops_manager_private_ip}
output "ops_manager_public_ip" { value =  local.stable_config.ops_manager_public_ip}
output "ops_manager_container_name" { value = local.stable_config.ops_manager_container_name}
output "ops_manager_dns" { value = local.stable_config.ops_manager_dns}
output "ops_manager_storage_account_name" { value =  local.stable_config.ops_manager_storage_account_name}

output "iaas_configuration_environment_azurecloud" { value =  local.stable_config.iaas_configuration_environment_azurecloud}
output "platform_vms_security_group_name" { value =  local.stable_config.platform_vms_security_group_name}

output "pas_subnet_name" { value =  local.stable_config.pas_subnet_name}
output "pas_subnet_id" { value =  local.stable_config.pas_subnet_id}
output "pas_subnet_cidr" { value =local.stable_config.pas_subnet_cidr}
output "pas_subnet_gateway" { value = local.stable_config.pas_subnet_gateway}
output "pas_subnet_range" { value =    local.stable_config.pas_subnet_range}

output "pas_buildpacks_container_name" { value    = local.stable_config.pas_buildpacks_container_name}
output "pas_packages_container_name" { value     = local.stable_config.pas_packages_container_name}
output "pas_droplets_container_name" { value     = local.stable_config.pas_droplets_container_name}
output "pas_resources_container_name" { value    = local.stable_config.pas_resources_container_name}
output "pas_storage_account_name" { value         = local.stable_config.pas_storage_account_name}
output "pas_storage_account_access_key" { value   = local.stable_config.pas_storage_account_access_key}

output "web_lb_name" { value  = local.stable_config.web_lb_name}
output "ssh_lb_name" { value  = local.stable_config.ssh_lb_name}
output "mysql_lb_name" { value  = local.stable_config.mysql_lb_name}
output "tcp_lb_name" { value  = local.stable_config.tcp_lb_name}
output "apps_dns_domain" { value   = local.stable_config.apps_dns_domain}
output "sys_dns_domain" { value   = local.stable_config.sys_dns_domain}
output "ssh_dns" { value  = local.stable_config.ssh_dns}
output "tcp_dns" { value  = local.stable_config.tcp_dns}
output "mysql_dns" { value = local.stable_config.mysql_dns}

output "pks_as_name" { value  = local.stable_config.pks_as_name}
output "pks_lb_name" { value  = local.stable_config.pks_lb_name}
output "pks_dns" { value   = local.stable_config.pks_dns}
output "pks_subnet_name" { value= local.stable_config.pks_subnet_name}
output "pks_subnet_id" { value   = local.stable_config.pks_subnet_id}
output "pks_subnet_cidr" { value  = local.stable_config.pks_subnet_cidr}
output "pks_subnet_gateway" { value  = local.stable_config.pks_subnet_gateway}
output "pks_subnet_range" { value   = local.stable_config.pks_subnet_range}
output "pks_api_application_security_group_name" { value = local.stable_config.pks_api_application_security_group_name}
output "pks_api_network_security_group_name" { value  =local.stable_config.pks_api_network_security_group_name}
output "pks_internal_network_security_group_name" { value  = local.stable_config.pks_internal_network_security_group_name}
output "pks_master_application_security_group_name" { value  = local.stable_config.pks_master_application_security_group_name}
output "pks_master_network_security_group_name" { value  = local.stable_config.pks_master_network_security_group_name}
output "pks_master_managed_identity" { value = local.stable_config.pks_master_managed_identity}
output "pks_worker_managed_identity" { value =local.stable_config.pks_worker_managed_identity}

output "services_subnet_name" { value = local.stable_config.services_subnet_name}
output "services_subnet_id" { value  = local.stable_config.services_subnet_id}
output "services_subnet_cidr" { value  = local.stable_config.services_subnet_cidr}
output "services_subnet_gateway" { value   = local.stable_config.services_subnet_gateway}
output "services_subnet_range" { value   = local.stable_config.services_subnet_range}

output "ssl_certificate" { value  = local.stable_config.ssl_certificate}
output "ssl_private_key" { value = local.stable_config.ssl_private_key}

output "paving_config_yaml" {
  value     = yamlencode(local.stable_config)
  sensitive = true
}
EOF
}
