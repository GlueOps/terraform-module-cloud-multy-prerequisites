resource "aws_iam_user" "autoglue" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.autoglue_aws_iam_user[each.key].result
}

resource "aws_iam_user_policy_attachment" "autoglue" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.autoglue
  user       = each.value.name
  policy_arn = aws_iam_policy.route53_autoglue[each.key].arn
  depends_on = [aws_iam_user.autoglue]
}

resource "aws_iam_access_key" "autoglue" {
  for_each   = aws_iam_user.autoglue
  provider   = aws.clientaccount
  user       = each.value.name
  depends_on = [aws_iam_user.autoglue]
}

resource "random_uuid" "autoglue_aws_iam_user" {
  for_each = aws_route53_zone.clusters
}