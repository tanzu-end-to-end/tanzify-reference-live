# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
# >> The project and hosted zone are expected to exist in advance fo executing Terragrunt
locals {
  environment_name ="mando" # This will be used to as a prefix for dns entries.
  hosted_zone = "ironleg-zone" # The DNS Zone name in GCP
  project = "fe-cphillipson" # GCP Project name
}
