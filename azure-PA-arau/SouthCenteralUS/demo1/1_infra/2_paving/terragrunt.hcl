
locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  location   = local.region_vars.locals.location
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone
    cloud_name = local.account_vars.locals.cloud_name
}

dependency "creds" {
  config_path = "../../0_secrets/secret-azure-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    azure_subscription_id = "fake"
    azure_tenant_id = "fake"
    azure_client_id = "fake"
    azure_client_secret = "fake"
  }
}

dependency "certs" {
  config_path = "../1_letsencrypt"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cert_full_chain = "fake"
    cert_private_key = "fake"
  }
}


terraform {
  # Terraform azure for PAS and TKGI using paving repo
  source = "git::git@github.com:abhinavrau/paving.git//azure"
}


inputs = {
  subscription_id = dependency.creds.outputs.azure_subscription_id
  tenant_id = dependency.creds.outputs.azure_tenant_id
  client_id = dependency.creds.outputs.azure_client_id
  client_secret = dependency.creds.outputs.azure_client_secret
  ssl_certificate = dependency.certs.outputs.cert_full_chain
  ssl_private_key = dependency.certs.outputs.cert_private_key

  location   = local.location
  environment_name = local.environment_name
  hosted_zone = local.hosted_zone
  cloud_name = local.cloud_name

}

generate "custom-output" {
  path = "custom-output.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

output "network_name" { value = local.stable_config_opsmanager.network_name }

output "resource_group_name" { value = local.stable_config_opsmanager.resource_group_name }

output "management_subnet_name" { value = local.stable_config_opsmanager.management_subnet_name}
output "management_subnet_id" { value   = local.stable_config_opsmanager.management_subnet_id}
output "management_subnet_cidr" { value = local.stable_config_opsmanager.management_subnet_cidr}
output "management_subnet_gateway" { value = local.stable_config_opsmanager.management_subnet_gateway}
output "management_subnet_range" { value = local.stable_config_opsmanager.management_subnet_range}

output "bosh_storage_account_name" { value  = local.stable_config_opsmanager.bosh_storage_account_name}

output "ops_manager_security_group_name" { value   = local.stable_config_opsmanager.ops_manager_security_group_name}
output "ops_manager_ssh_private_key" { value = local.stable_config_opsmanager.ops_manager_ssh_private_key}
output "ops_manager_ssh_public_key" { value =  local.stable_config_opsmanager.ops_manager_ssh_public_key}
output "ops_manager_private_ip" { value = local.stable_config_opsmanager.ops_manager_private_ip}
output "ops_manager_public_ip" { value =  local.stable_config_opsmanager.ops_manager_public_ip}
output "ops_manager_container_name" { value = local.stable_config_opsmanager.ops_manager_container_name}
output "ops_manager_dns" { value = local.stable_config_opsmanager.ops_manager_dns}
output "ops_manager_storage_account_name" { value =  local.stable_config_opsmanager.ops_manager_storage_account_name}

output "iaas_configuration_environment_azurecloud" { value =  local.stable_config_opsmanager.iaas_configuration_environment_azurecloud}
output "platform_vms_security_group_name" { value =  local.stable_config_opsmanager.platform_vms_security_group_name}

output "services_subnet_name" { value = local.stable_config_opsmanager.services_subnet_name}
output "services_subnet_id" { value  = local.stable_config_opsmanager.services_subnet_id}
output "services_subnet_cidr" { value  = local.stable_config_opsmanager.services_subnet_cidr}
output "services_subnet_gateway" { value   = local.stable_config_opsmanager.services_subnet_gateway}
output "services_subnet_range" { value   = local.stable_config_opsmanager.services_subnet_range}

output "ssl_certificate" { value  = local.stable_config_opsmanager.ssl_certificate}
output "ssl_private_key" { value = local.stable_config_opsmanager.ssl_private_key}

output "pas_subnet_name" { value =  local.stable_config_pas.pas_subnet_name}
output "pas_subnet_id" { value =  local.stable_config_pas.pas_subnet_id}
output "pas_subnet_cidr" { value =local.stable_config_pas.pas_subnet_cidr}
output "pas_subnet_gateway" { value = local.stable_config_pas.pas_subnet_gateway}
output "pas_subnet_range" { value =    local.stable_config_pas.pas_subnet_range}

output "pas_buildpacks_container_name" { value    = local.stable_config_pas.pas_buildpacks_container_name}
output "pas_packages_container_name" { value     = local.stable_config_pas.pas_packages_container_name}
output "pas_droplets_container_name" { value     = local.stable_config_pas.pas_droplets_container_name}
output "pas_resources_container_name" { value    = local.stable_config_pas.pas_resources_container_name}
output "pas_storage_account_name" { value         = local.stable_config_pas.pas_storage_account_name}
output "pas_storage_account_access_key" { value   = local.stable_config_pas.pas_storage_account_access_key}

output "web_lb_name" { value  = local.stable_config_pas.web_lb_name}
output "ssh_lb_name" { value  = local.stable_config_pas.ssh_lb_name}
output "mysql_lb_name" { value  = local.stable_config_pas.mysql_lb_name}
output "tcp_lb_name" { value  = local.stable_config_pas.tcp_lb_name}
output "apps_dns_domain" { value   = local.stable_config_pas.apps_dns_domain}
output "sys_dns_domain" { value   = local.stable_config_pas.sys_dns_domain}
output "ssh_dns" { value  = local.stable_config_pas.ssh_dns}
output "tcp_dns" { value  = local.stable_config_pas.tcp_dns}
output "mysql_dns" { value = local.stable_config_pas.mysql_dns}

output "pks_as_name" { value  = local.stable_config_pks.pks_as_name}
output "pks_lb_name" { value  = local.stable_config_pks.pks_lb_name}
output "pks_dns" { value   = local.stable_config_pks.pks_dns}
output "pks_subnet_name" { value= local.stable_config_pks.pks_subnet_name}
output "pks_subnet_id" { value   = local.stable_config_pks.pks_subnet_id}
output "pks_subnet_cidr" { value  = local.stable_config_pks.pks_subnet_cidr}
output "pks_subnet_gateway" { value  = local.stable_config_pks.pks_subnet_gateway}
output "pks_subnet_range" { value   = local.stable_config_pks.pks_subnet_range}
output "pks_api_application_security_group_name" { value = local.stable_config_pks.pks_api_application_security_group_name}
output "pks_api_network_security_group_name" { value  =local.stable_config_pks.pks_api_network_security_group_name}
output "pks_internal_network_security_group_name" { value  = local.stable_config_pks.pks_internal_network_security_group_name}
output "pks_master_application_security_group_name" { value  = local.stable_config_pks.pks_master_application_security_group_name}
output "pks_master_network_security_group_name" { value  = local.stable_config_pks.pks_master_network_security_group_name}
output "pks_master_managed_identity" { value = local.stable_config_pks.pks_master_managed_identity}
output "pks_worker_managed_identity" { value =local.stable_config_pks.pks_worker_managed_identity}


EOF
}
