

resource "aws_iam_user" "loki_s3" {
  provider = aws.clientaccount
  for_each = { for entry in local.bucketkeys_cluster : "${entry.bucketKey}.${entry.cluster}" => entry }
  name     = "${each.value.bucketKey}-s3-${each.value.cluster}"
}

resource "aws_iam_user_policy_attachment" "loki_s3" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.loki_s3
  user       = each.value.name
  policy_arn = aws_iam_policy.loki_s3[each.key].arn
  depends_on = [aws_iam_user.loki_s3]
}

resource "aws_iam_access_key" "loki_s3" {
  for_each   = aws_iam_user.loki_s3
  provider   = aws.clientaccount
  user       = each.value.name
  depends_on = [aws_iam_user.loki_s3]
}
