# Set common variables for the environment. This is pulled into terragrunt.hcl configuration
locals {
  # This will be used to append to dns entries and a new resource group will be created with this name
  environment_name = "demo1"
  # The DNS name of that is registered in Azure to use for this install accessible via the Azure account.
  hosted_zone = "azure.pcf-arau.pw"
}
