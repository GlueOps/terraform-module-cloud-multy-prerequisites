resource "aws_iam_policy" "loki_s3_v2" {
  provider = aws.clientaccount
  for_each = module.loki_s3
  name     = random_uuid.loki_aws_iam_policy[each.key].result
  policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
              "s3:ListBucket",
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
            ],
            "Effect": "Allow",
            "Resource": [
              "${module.loki_s3[each.key].primary_s3_bucket_arn}",
              "${module.loki_s3[each.key].primary_s3_bucket_arn}/*"
            ]
        }
    ]
}
EOF

  tags = {
    Name = "loki-s3-${aws_route53_zone.clusters[each.key].name}"
  }
}

resource "random_uuid" "loki_aws_iam_policy" {
  for_each = module.loki_s3
}