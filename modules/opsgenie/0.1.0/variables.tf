variable "users" {
  description = "List of user email addresses"
  type        = list(string)
}

variable "tenant_key" {
  description = "Unique identifier for the tenant"
  type        = string
}

variable "cluster_environments" {
  description = "List of cluster environment names"
  type        = list(string)
}
