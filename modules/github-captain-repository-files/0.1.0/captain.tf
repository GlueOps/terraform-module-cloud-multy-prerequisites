resource "github_repository_file" "files" {
  for_each            = var.files_to_create
  repository          = var.repository_name
  branch              = "main"
  file                = each.key
  content             = each.value
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "github@glueops.dev"
  overwrite_on_create = true
}
