

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

}


dependency "creds" {
  config_path = "../../0_secrets/secret-aws-creds"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    access_key =  "fake"
    secret_key =  "fake"
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
  source = "git::https://github.com/abhinavrau/paving.git//aws"
}


inputs = {
  region   = local.region
  environment_name = local.environment_name
  hosted_zone = local.hosted_zone
  access_key =  dependency.creds.outputs.access_key
  secret_key =  dependency.creds.outputs.secret_access_token
  availability_zones = local.availability_zones
  ssl_certificate = dependency.certs.outputs.cert_full_chain
  ssl_private_key = dependency.certs.outputs.cert_private_key

}


// Output all the outputs for other modules to consume
generate "custom-output" {
  path = "custom-output.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF


output "vpc_id" { value = local.stable_config_opsmanager.vpc_id }

output "public_subnet_ids" { value = local.stable_config_opsmanager.public_subnet_ids }
output "public_subnet_cidrs" { value = local.stable_config_opsmanager.public_subnet_cidrs }

output "management_subnet_ids" { value = local.stable_config_opsmanager.management_subnet_ids}
output "management_subnet_cidrs" { value = local.stable_config_opsmanager.management_subnet_cidrs}
output "management_subnet_gateways" { value = local.stable_config_opsmanager.management_subnet_gateways}
output "management_subnet_reserved_ip_ranges" { value = local.stable_config_opsmanager.management_subnet_reserved_ip_ranges}

output "ops_manager_subnet_id" { value  = local.stable_config_opsmanager.ops_manager_subnet_id}
output "ops_manager_public_ip" { value  = local.stable_config_opsmanager.ops_manager_public_ip}
output "ops_manager_dns" { value =  local.stable_config_opsmanager.ops_manager_dns}
output "ops_manager_iam_user_access_key" { value = local.stable_config_opsmanager.ops_manager_iam_user_access_key}
output "ops_manager_iam_user_secret_key" { value =  local.stable_config_opsmanager.ops_manager_iam_user_secret_key}
output "ops_manager_iam_instance_profile_name" { value = local.stable_config_opsmanager.ops_manager_iam_instance_profile_name}
output "ops_manager_key_pair_name" { value =  local.stable_config_opsmanager.ops_manager_key_pair_name}
output "ops_manager_ssh_public_key" { value =  local.stable_config_opsmanager.ops_manager_ssh_public_key}
output "ops_manager_ssh_private_key" { value =  local.stable_config_opsmanager.ops_manager_ssh_private_key}
output "ops_manager_bucket" { value =  local.stable_config_opsmanager.ops_manager_bucket}
output "ops_manager_security_group_id" { value =  local.stable_config_opsmanager.ops_manager_security_group_id}
output "ops_manager_security_group_name" { value =  local.stable_config_opsmanager.ops_manager_security_group_name}

output "platform_vms_security_group_id" { value =  local.stable_config_opsmanager.platform_vms_security_group_id}
output "platform_vms_security_group_name" { value =  local.stable_config_opsmanager.platform_vms_security_group_name}

output "nat_security_group_id" { value =  local.stable_config_opsmanager.nat_security_group_id}
output "nat_security_group_name" { value =  local.stable_config_opsmanager.nat_security_group_name}


output "services_subnet_ids" { value = local.stable_config_opsmanager.services_subnet_ids}
output "services_subnet_cidrs" { value  = local.stable_config_opsmanager.services_subnet_cidrs}
output "services_subnet_gateways" { value   = local.stable_config_opsmanager.services_subnet_gateways}
output "services_subnet_reserved_ip_ranges" { value   = local.stable_config_opsmanager.services_subnet_reserved_ip_ranges}

output "ssl_certificate" { value  = local.stable_config_opsmanager.ssl_certificate}
output "ssl_private_key" { value = local.stable_config_opsmanager.ssl_private_key}

// TAS outputs.
output "pas_subnet_ids" { value =  local.stable_config_pas.pas_subnet_ids}
output "pas_subnet_cidrs" { value =local.stable_config_pas.pas_subnet_cidrs}
output "pas_subnet_gateways" { value = local.stable_config_pas.pas_subnet_gateways}
output "pas_subnet_reserved_ip_ranges" { value =    local.stable_config_pas.pas_subnet_reserved_ip_ranges}

output "buildpacks_bucket_name" { value    = local.stable_config_pas.buildpacks_bucket_name}
output "droplets_bucket_name" { value     = local.stable_config_pas.droplets_bucket_name}
output "packages_bucket_name" { value     = local.stable_config_pas.packages_bucket_name}
output "resources_bucket_name" { value    = local.stable_config_pas.resources_bucket_name}
output "tas_blobstore_iam_instance_profile_name" { value         = local.stable_config_pas.tas_blobstore_iam_instance_profile_name}

output "ssh_lb_security_group_id" { value  = local.stable_config_pas.ssh_lb_security_group_id}
output "ssh_lb_security_group_name" { value  = local.stable_config_pas.ssh_lb_security_group_name}
output "ssh_target_group_name" { value  = local.stable_config_pas.ssh_target_group_name}

output "tcp_lb_security_group_id" { value   = local.stable_config_pas.tcp_lb_security_group_id}
output "tcp_lb_security_group_name" { value  = local.stable_config_pas.tcp_lb_security_group_name}
output "tcp_target_group_names" { value  = local.stable_config_pas.tcp_target_group_names}

output "web_lb_security_group_id" { value   = local.stable_config_pas.web_lb_security_group_id}
output "web_lb_security_group_name" { value  = local.stable_config_pas.web_lb_security_group_name}
output "web_target_group_names" { value  = local.stable_config_pas.web_target_group_names}

output "mysql_security_group_id" { value  = local.stable_config_pas.mysql_security_group_id}
output "mysql_security_group_name" { value  = local.stable_config_pas.mysql_security_group_name}

output "sys_dns_domain" { value   = local.stable_config_pas.sys_dns_domain}
output "apps_dns_domain" { value   = local.stable_config_pas.apps_dns_domain}
output "ssh_dns" { value   = local.stable_config_pas.ssh_dns}
output "tcp_dns" { value   = local.stable_config_pas.tcp_dns}


// TKGI outputs.
output "pks_master_iam_instance_profile_name" { value  = local.stable_config_pks.pks_master_iam_instance_profile_name}
output "pks_worker_iam_instance_profile_name" { value  = local.stable_config_pks.pks_worker_iam_instance_profile_name}

output "pks_api_dns" { value =local.stable_config_pks.pks_api_dns}

output "pks_subnet_ids" { value  = local.stable_config_pks.pks_subnet_ids}
output "pks_subnet_cidrs" { value  = local.stable_config_pks.pks_subnet_cidrs}
output "pks_subnet_gateways" { value  = local.stable_config_pks.pks_subnet_gateways}
output "pks_subnet_reserved_ip_ranges" { value   = local.stable_config_pks.pks_subnet_reserved_ip_ranges}
output "pks_internal_security_group_id" { value  = local.stable_config_pks.pks_internal_security_group_id}
output "pks_internal_security_group_name" { value =local.stable_config_pks.pks_internal_security_group_name}
output "pks_api_lb_security_group_id" { value  = local.stable_config_pks.pks_api_lb_security_group_id}
output "pks_api_lb_security_group_name" { value  = local.stable_config_pks.pks_api_lb_security_group_name}
output "pks_api_target_groups" { value  = local.stable_config_pks.pks_api_target_groups}



EOF
}
