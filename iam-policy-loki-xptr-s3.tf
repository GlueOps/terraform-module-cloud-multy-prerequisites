resource "aws_iam_policy" "vault_s3_backup" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "loki-xptr-s3-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:ListObject"
      ],
      "Resource": [
        "${module.common_s3.primary_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/loki_exported_logs/*",
        "${module.common_s3.replica_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/loki_exported_logs/*"
      ]
    }
  ]
}
EOF
}
