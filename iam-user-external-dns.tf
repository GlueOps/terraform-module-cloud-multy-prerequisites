resource "aws_iam_user" "externaldns" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "externaldns-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_user_policy_attachment" "externaldns" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.externaldns
  user       = each.value.name
  policy_arn = aws_iam_policy.route53[each.key].arn
}

resource "aws_iam_access_key" "externaldns" {
  for_each = aws_iam_user.externaldns
  provider = aws.clientaccount
  user     = each.value.name
}

# output "externaldns_credentials" {
#   value = { for user, keys in aws_iam_access_key.externaldns : aws_route53_zone.clusters[user].name => keys }
#   description = "A map of IAM Access Keys to Route53 for external-dns. One per Cluster Environment"
# }
