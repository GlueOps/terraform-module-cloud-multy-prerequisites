resource "aws_iam_user" "vault_init_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "vault-init-s3-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_user_policy_attachment" "vault_init_s3" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.vault_init_s3
  user       = each.value.name
  policy_arn = aws_iam_policy.vault_init_s3[each.key].arn
}

resource "aws_iam_access_key" "vault_init_s3" {
  for_each = aws_iam_user.vault_init_s3
  provider = aws.clientaccount
  user     = each.value.name
}
