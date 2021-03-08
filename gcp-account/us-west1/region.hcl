# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals  {
  region = "us-west1"
  availability_zones = ["us-west1-a","us-west1-b","us-west1-c"]
}