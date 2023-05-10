module "captain_repository" {
  for_each       = toset(["captain-repo-test1"])
  source         = "./modules/github-captain-repository"
  repostory_name = each.key
  files_to_create = [
    {
      "README.md" = "This is a README file"
  }]
}