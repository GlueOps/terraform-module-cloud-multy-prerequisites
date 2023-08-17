resource "aws_iam_policy" "vault_init_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "vault-init-s3-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject*"
      ],
      "Resource": [
        "${module.common_s3.primary_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*",
        "${module.common_s3.replica_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*"
      ]
    }
  ]
}
EOF
}
