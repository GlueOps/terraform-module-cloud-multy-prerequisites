

resource "github_repository" "captain_repo" {
  name       = var.repository_name
  visibility = "private"
  auto_init  = true
}


resource "github_repository_file" "files" {
  for_each            = var.files_to_create
  repository          = github_repository.captain_repo.name
  branch              = "main"
  file                = each.key
  content             = each.value
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}
