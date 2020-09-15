# Set common variables for the environment. This is pulled into terragrunt.hcl configuration
locals {
  environment_name = "demo1" # This will be used to append to dns entries.
  hosted_zone = "azure.pcf-arau.pw"
}
