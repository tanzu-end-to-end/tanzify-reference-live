# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment_name = "hamster" # This will be used to as a prefix for dns entries.
  hosted_zone = "zoolabs.me" # The DNS Zone name in AWS that registers a domain to use for this install.
}
