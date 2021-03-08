generate "custom-output" {
  path = "outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  output "access_key" {
    value = var.aws_access_key
  }

  output "secret_access_token" {
    value = var.aws_secret_key
  }
EOF
}

terraform {
  source = pathexpand("../../../../../modules/aws")
}

inputs = {
  access_key = "why-would-i-share-this-with-you"
  secret_access_token = "why-would-i-share-this-with-you"
}
