resource "aws_iam_user" "certmanager_v2" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.certmanager_v2_aws_iam_user[each.key].result
  tags = {
    Name = "certmanager-${aws_route53_zone.clusters[each.key].name}"
  }
}

resource "aws_iam_user_policy_attachment" "certmanager_v2" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.certmanager_v2
  user       = each.value.name
  policy_arn = aws_iam_policy.route53_v2[each.key].arn
  depends_on = [aws_iam_user.certmanager_v2]
}

resource "aws_iam_access_key" "certmanager_v2" {
  for_each   = aws_iam_user.certmanager_v2
  provider   = aws.clientaccount
  user       = each.value.name
  depends_on = [aws_iam_user.certmanager_v2]
}


resource "random_uuid" "certmanager_v2_aws_iam_user" {
  for_each = aws_route53_zone.clusters
}