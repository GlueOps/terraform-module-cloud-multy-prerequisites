resource "aws_iam_policy" "vault_init_s3_v2" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.vault_init_s3_v2_aws_iam_policy[each.key].result
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject*",
        "s3:List*"
      ],
      "Resource": [
        "${module.common_s3_v2.s3_multi_region_access_point_arn_for_object_level_policies}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*",
        "${module.common_s3_v2.s3_primary_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*",
        "${module.common_s3_v2.s3_replica_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-init/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*",
        "s3:List*"
      ],
      "Resource": [
        "${module.common_s3_v2.s3_multi_region_access_point_arn_for_object_level_policies}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*",
        "${module.common_s3_v2.s3_primary_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*",
        "${module.common_s3_v2.s3_replica_arn}/${aws_route53_zone.clusters[each.key].name}/hashicorp-vault-backups/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "${module.common_s3_v2.s3_multi_region_access_point_arn}",
        "${module.common_s3_v2.s3_primary_arn}",
        "${module.common_s3_v2.s3_replica_arn}"

      ]
    }
  ]
}
EOF
  tags = {
    Name = "vault-init-s3-${aws_route53_zone.clusters[each.key].name}"
  }
}


resource "random_uuid" "vault_init_s3_v2_aws_iam_policy" {
  for_each = aws_route53_zone.clusters
}
