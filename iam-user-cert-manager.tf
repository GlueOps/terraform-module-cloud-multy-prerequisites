resource "aws_iam_user" "certmanager" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "certmanager-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_user_policy_attachment" "certmanager" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.certmanager
  user       = each.value.name
  policy_arn = aws_iam_policy.route53[each.key].arn
}

resource "aws_iam_access_key" "certmanager" {
  for_each = aws_iam_user.certmanager
  provider = aws.clientaccount
  user     = each.value.name
}
