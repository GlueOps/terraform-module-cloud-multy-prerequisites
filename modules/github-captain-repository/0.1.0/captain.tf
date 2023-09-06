

resource "github_repository" "captain_repo" {
  name                 = var.repository_name
  visibility           = "private"
  auto_init            = true
  vulnerability_alerts = true
}

resource "github_repository_deploy_key" "captain_repo_deploy_key" {
  repository = github_repository.captain_repo.name
  title      = "ArgoCD Deploy Key"
  key        = trimspace(tls_private_key.captain_repo_deploy_key.public_key_openssh)
  read_only  = true
}

resource "tls_private_key" "captain_repo_deploy_key" {
  algorithm = "ED25519"
}

output "ssh_clone_url" {
  value = github_repository.captain_repo.ssh_clone_url
}


output "private_deploy_key" {
  value = tls_private_key.captain_repo_deploy_key.private_key_openssh
}

output "repository_name" {
  value = github_repository.captain_repo.name
}
