resource "aws_iam_user" "loki_s3_v2" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_string.loki_aws_iam_user[each.key].result
}

resource "aws_iam_user_policy_attachment" "loki_s3_v2" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.loki_s3_v2
  user       = each.value.name
  policy_arn = aws_iam_policy.loki_s3_v2[each.key].arn
  depends_on = [aws_iam_user.loki_s3_v2]
}

resource "aws_iam_access_key" "loki_s3_v2" {
  for_each   = aws_iam_user.loki_s3_v2
  provider   = aws.clientaccount
  user       = each.value.name
  depends_on = [aws_iam_user.loki_s3_v2]
}


resource "random_string" "loki_aws_iam_user" {
  for_each = aws_route53_zone.clusters
  length   = 127
  special  = false
  lower    = true
  number   = false
  numeric  = false
  upper    = false
}