resource "aws_iam_user" "tls_cert_restore_s3_v2" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.tls_cert_restore_s3_v2_aws_iam_user[each.key].result
  tags = {
    Name = "tls-cert-restore-s3-${aws_route53_zone.clusters[each.key].name}"
  }
}

resource "aws_iam_user_policy_attachment" "tls_cert_restore_s3_v2" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.tls_cert_restore_s3_v2
  user       = each.value.name
  policy_arn = aws_iam_policy.tls_cert_restore_s3_v2[each.key].arn
  depends_on = [aws_iam_user.tls_cert_restore_s3_v2]
}

resource "aws_iam_access_key" "tls_cert_restore_s3_v2" {
  for_each   = aws_iam_user.tls_cert_restore_s3_v2
  provider   = aws.clientaccount
  user       = each.value.name
  depends_on = [aws_iam_user.tls_cert_restore_s3_v2]
}

resource "random_uuid" "tls_cert_restore_s3_v2_aws_iam_user" {
  for_each = aws_route53_zone.clusters
}