# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals  {
  region = "us-east-1"
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
}