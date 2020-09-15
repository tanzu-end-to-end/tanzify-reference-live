locals {
  # Automatically load variables
  azure_vars = read_terragrunt_config("azure.hcl")

  azure_service_account_LastPassID =   local.azure_vars.locals.azure_service_account_LastPassID
}
generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "azure_subscription_id" {
    value = data.lastpass_secret.credentials.custom_fields.subscription_id
  }

  output "azure_client_id" {
    value = data.lastpass_secret.credentials.custom_fields.client_id
  }
  output "azure_client_secret" {
    value = data.lastpass_secret.credentials.custom_fields.client_secret
    sensitive = true
  }
  output "azure_tenant_id" {
    value = data.lastpass_secret.credentials.custom_fields.tenant_id
  }
EOF
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//secret-store/lastpass"

}

inputs = {
  credential-LastPassID = local.azure_service_account_LastPassID
}
