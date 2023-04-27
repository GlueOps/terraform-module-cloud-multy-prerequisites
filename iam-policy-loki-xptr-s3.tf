resource "aws_iam_policy" "loki_logs_exporter_s3" {
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
        "s3:ListObject",
        "s3:HeadObject",
        "s3:ListBucket",
        "s3:GetObjectAttributes",
        "s3:GetObject"
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
