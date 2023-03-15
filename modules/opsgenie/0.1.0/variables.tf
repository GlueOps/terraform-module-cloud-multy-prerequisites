variable "users" {
  description = "List of user email addresses"
  type        = list(string)
}

variable "company_key" {
  description = "Unique identifier for the company"
  type        = string
}

variable "cluster_environments" {
  description = "List of cluster environment names"
  type        = list(string)
}
