generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "azure_subscription_id" {
    value = var.azure_subscription_id
    sensitive = true
  }

  output "azure_client_id" {
    value = var.azure_client_id
    sensitive = true
  }
  output "azure_client_secret" {
    value = var.azure_client_secret
    sensitive = true
  }
  output "azure_tenant_id" {
    value = var.azure_tenant_id
    sensitive = true
  }
EOF
}

terraform {
  source = pathexpand("../../../../../modules/azure")
}

inputs = {
  az_client_id = "why-would-i-share-this-with-you"
  az_client_secret = "why-would-i-share-this-with-you"
  az_subscription_id = "why-would-i-share-this-with-you"
  az_tenant_id = "why-would-i-share-this-with-you"
}
