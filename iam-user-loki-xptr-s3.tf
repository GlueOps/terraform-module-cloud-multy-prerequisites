resource "aws_iam_user" "loki_log_exporter_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "loki-xptr-s3-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_user_policy_attachment" "loki_log_exporter_s3" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.loki_log_exporter_s3
  user       = each.value.name
  policy_arn = aws_iam_policy.loki_log_exporter_s3_backup[each.key].arn
}

resource "aws_iam_access_key" "loki_log_exporter_s3" {
  for_each = aws_iam_user.loki_log_exporter_s3
  provider = aws.clientaccount
  user     = each.value.name
}
