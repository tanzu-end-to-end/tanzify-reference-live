data "local_file" "keyfile" {
  filename = pathexpand(var.keyfile_path)
}

variable "keyfile_path" {
  type = string
  description = "Path to Google Service Account key file (where contents are in JSON format)"
}