# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals  {
  region = "us-west-1"
  availability_zones = ["us-west-1a","us-west-1b","us-west-1c"]
}