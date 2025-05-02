resource "aws_iam_policy" "vault_s3_backup_v2" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.vault_s3_backup_v2_aws_iam_policy[each.key].result

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "${module.common_s3.primary_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*",
        "${module.common_s3.replica_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${module.common_s3.primary_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*",
        "${module.common_s3.replica_s3_bucket_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*"
      ]
    }
  ]
}
EOF
  tags = {
    Name = "vault-s3-${aws_route53_zone.clusters[each.key].name}"
  }
}

resource "random_uuid" "vault_s3_backup_v2_aws_iam_policy" {
  for_each = aws_route53_zone.clusters
}
