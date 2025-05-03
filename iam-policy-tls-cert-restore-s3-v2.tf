resource "aws_iam_policy" "tls_cert_restore_s3_v2" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.tls_cert_restore_s3_v2_aws_iam_policy[each.key].result
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*",
        "s3:ListBucket*"
      ],
      "Resource": [
        "${module.common_s3_v2.s3_multi_region_access_point_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*"
      ],
      "Resource": [
        "${module.common_s3_v2.s3_multi_region_access_point_arn}/${aws_route53_zone.clusters[each.key].name}/tls-cert-backups/*"
      ]
    }
  ]
}
EOF
  tags = {
    Name = "tls-cert-restore-s3-${aws_route53_zone.clusters[each.key].name}"
  }
}


resource "random_uuid" "tls_cert_restore_s3_v2_aws_iam_policy" {
  for_each = aws_route53_zone.clusters
}