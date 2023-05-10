

resource "github_repository" "captain_repo" {
  name       = var.repostory_name
  visibility = "private"
  auto_init = true
}


resource "github_repository_file" "gitignore" {
  repository          = github_repository.captain_repo.name
  branch              = "main"
  file                = ".gitignore"
  content             = "**/*.tfstate"
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}