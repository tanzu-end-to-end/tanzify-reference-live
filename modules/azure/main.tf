variable "az_subscription_id" {
  type = string
  description = "Azure Subscription id"
  sensitive = true
}

variable "az_client_id" {
  type = string
  description = "Azure Service Principal appId"
  sensitive = true
}

variable "az_client_secret" {
  type = string
  description = "Azure Service Principal password"
  sensitive = true
}

variable "az_tenant_id" {
  type = string
  description = "Azure Service Principal tenant"
  sensitive = true
}
