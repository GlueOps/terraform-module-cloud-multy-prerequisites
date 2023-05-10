module "captain_repository" {
  for_each = toset(["captain-repo-test","captain-repo-test1"])
  source         = "./modules/github-captain-repository"
  repostory_name = each.key
  organization   = "development-captains"
}