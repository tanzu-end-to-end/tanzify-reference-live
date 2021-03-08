variable "aws_access_key" {
  type = string
  description = "Access key for the IAM User with policy attachment that provides appropriate permissions to set records in Route53 zone"
  sensitive = true
}

variable "aws_secret_key" {
  type = string
  description = "Secret key for the IAM User with policy attachment that provides appropriate permissions to set records in Route53 zone"
  sensitive = true
}