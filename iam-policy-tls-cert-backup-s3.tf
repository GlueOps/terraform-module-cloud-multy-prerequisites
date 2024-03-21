resource "aws_iam_policy" "tls_cert_backup_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "tls-cert-backup-s3-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:List*"
      ],
      "Resource": [
        "${module.common_s3.primary_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/tls-cert-backups/*"
      ]
    }
  ]
}
EOF
}
