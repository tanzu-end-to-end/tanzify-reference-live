
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access

  region   = local.region_vars.locals.region
  availability_zones = local.region_vars.locals.availability_zones
  environment_name = local.environment_vars.locals.environment_name
  hosted_zone = local.environment_vars.locals.hosted_zone
  project = local.environment_vars.locals.project
}


dependency "creds" {
  config_path = "../0_secrets/secret-gcp-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    service_account_key = "fake"
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
  source = "git::git@github.com:abhinavrau/paving.git//gcp"
}


inputs = {
  region   = local.region
  environment_name = local.environment_name
  hosted_zone = local.hosted_zone
  project = local.project
  availability_zones = local.availability_zones
  service_account_key =  dependency.creds.outputs.service_account_key
  ssl_certificate = dependency.certs.outputs.cert_full_chain
  ssl_private_key = dependency.certs.outputs.cert_private_key
  service_account_key = dependency.creds.outputs.service_account_key
}


// Output all the outputs for other modules to consume
generate "custom-output" {
  path = "custom-output.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

output "network_name" { value = local.stable_config_opsmanager.network_name }

output "hosted_zone_name_servers" { value = local.stable_config_opsmanager.hosted_zone_name_servers }

output "management_subnet_name" { value = local.stable_config_opsmanager.management_subnet_name}
output "management_subnet_cidr" { value = local.stable_config_opsmanager.management_subnet_cidr}
output "management_subnet_gateway" { value = local.stable_config_opsmanager.management_subnet_gateway}
output "management_subnet_reserved_ip_ranges" { value = local.stable_config_opsmanager.management_subnet_reserved_ip_ranges}

output "ops_manager_bucket" { value  = local.stable_config_opsmanager.ops_manager_bucket}
output "ops_manager_dns" { value  = local.stable_config_opsmanager.ops_manager_dns}
output "ops_manager_public_ip" { value =  local.stable_config_opsmanager.ops_manager_public_ip}
output "ops_manager_service_account_key" { value = local.stable_config_opsmanager.ops_manager_service_account_key}
output "ops_manager_ssh_public_key" { value =  local.stable_config_opsmanager.ops_manager_ssh_public_key}
output "ops_manager_ssh_private_key" { value = local.stable_config_opsmanager.ops_manager_ssh_private_key}
output "ops_manager_tags" { value =  local.stable_config_opsmanager.ops_manager_tags}
output "platform_vms_tag" { value =  local.stable_config_opsmanager.platform_vms_tag}

output "services_subnet_name" { value = local.stable_config_opsmanager.services_subnet_name}
output "services_subnet_cidr" { value  = local.stable_config_opsmanager.services_subnet_cidr}
output "services_subnet_gateway" { value   = local.stable_config_opsmanager.services_subnet_gateway}
output "services_subnet_reserved_ip_ranges" { value   = local.stable_config_opsmanager.services_subnet_reserved_ip_ranges}

output "ssl_certificate" { value  = local.stable_config_opsmanager.ssl_certificate}
output "ssl_private_key" { value = local.stable_config_opsmanager.ssl_private_key}


output "pas_subnet_name" { value =  local.stable_config_pas.pas_subnet_name}
output "pas_subnet_cidr" { value =local.stable_config_pas.pas_subnet_cidr}
output "pas_subnet_gateway" { value = local.stable_config_pas.pas_subnet_gateway}
output "pas_subnet_reserved_ip_ranges" { value =    local.stable_config_pas.pas_subnet_reserved_ip_ranges}

output "buildpacks_bucket_name" { value    = local.stable_config_pas.buildpacks_bucket_name}
output "droplets_bucket_name" { value     = local.stable_config_pas.droplets_bucket_name}
output "packages_bucket_name" { value     = local.stable_config_pas.packages_bucket_name}
output "resources_bucket_name" { value    = local.stable_config_pas.resources_bucket_name}
output "backup_bucket_name" { value         = local.stable_config_pas.backup_bucket_name}

output "http_backend_service_name" { value  = local.stable_config_pas.http_backend_service_name}
output "ssh_target_pool_name" { value  = local.stable_config_pas.ssh_target_pool_name}
output "tcp_target_pool_name" { value  = local.stable_config_pas.tcp_target_pool_name}
output "web_target_pool_name" { value   = local.stable_config_pas.web_target_pool_name}

output "sys_dns_domain" { value   = local.stable_config_pas.sys_dns_domain}
output "apps_dns_domain" { value   = local.stable_config_pas.apps_dns_domain}
output "doppler_dns" { value   = local.stable_config_pas.doppler_dns}
output "loggregator_dns" { value   = local.stable_config_pas.loggregator_dns}
output "ssh_dns" { value  = local.stable_config_pas.ssh_dns}
output "tcp_dns" { value  = local.stable_config_pas.tcp_dns}


output "pks_subnet_name" { value  = local.stable_config_pks.pks_subnet_name}
output "pks_subnet_cidr" { value  = local.stable_config_pks.pks_subnet_cidr}
output "pks_subnet_gateway" { value  = local.stable_config_pks.pks_subnet_gateway}
output "pks_subnet_reserved_ip_ranges" { value   = local.stable_config_pks.pks_subnet_reserved_ip_ranges}
output "pks_master_node_service_account_id" { value  = local.stable_config_pks.pks_master_node_service_account_id}
output "pks_worker_node_service_account_id" { value =local.stable_config_pks.pks_worker_node_service_account_id}
output "pks_api_target_pool_name" { value  = local.stable_config_pks.pks_api_target_pool_name}
output "pks_api_dns_domain" { value =local.stable_config_pks.pks_api_dns_domain}



EOF
}
