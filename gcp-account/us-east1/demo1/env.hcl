# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment_name ="demo1" # This will be used to as a prefix for dns entries.
  hosted_zone = "paasify-zone" # The DNS Zone name in GCP
  project = "pa-arau" # GCP Project name
}
