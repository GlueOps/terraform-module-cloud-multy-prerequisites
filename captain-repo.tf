module "captain_repository" {
  source         = "./modules/github-captain-repository"
  repostory_name = "captain-repo-test1"
  organization   = "development-captains"
}