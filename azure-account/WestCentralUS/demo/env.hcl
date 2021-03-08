# Set common variables for the environment. This is pulled into terragrunt.hcl configuration
locals {
  # This will be used to append to dns entries and a new resource group will be created with this name
  environment_name = "lando"
  # The DNS name that is registered in Azure to use for this install accessible via the Azure account.
  hosted_zone = "cloudmonk.me"
}
