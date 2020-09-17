# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment_name ="demo1" # This will be used to as a prefix for dns entries.
  hosted_zone = "aws.pcf-arau.pw" # The DNS Zone name in AWS that registers a domain to use for this install.
}
