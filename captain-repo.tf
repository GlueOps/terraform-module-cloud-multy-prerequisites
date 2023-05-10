module "captain_repository" {
  source         = "./modules/github-captain-repository"
  repostory_name = "captain-repo"
  github_organization   = "development-captains"
}