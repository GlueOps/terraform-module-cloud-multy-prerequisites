variable "repostory_name" {
  type     = string
  nullable = false
  default  = false
}

variable "files_to_create" {
  type     = map(string)
  nullable = false
  default  = {}
}
