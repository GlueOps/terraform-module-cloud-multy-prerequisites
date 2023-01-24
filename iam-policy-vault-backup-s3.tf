resource "aws_iam_policy" "vault_s3_backup" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "vault-s3-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.primary.arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*",
        "${aws_s3_bucket.replica.arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*"
      ]
    }
  ]
}
EOF
}
