resource "aws_iam_policy" "loki_s3" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "loki-s3-${aws_route53_zone.clusters[each.key].name}"
  # TODO - update bucket name
  policy = <<EOF
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
              "${aws_s3_bucket.primary.arn}/${aws_route53_zone.clusters[each.key].name}",
              "${aws_s3_bucket.replica.arn}/${aws_route53_zone.clusters[each.key].name}/*"
            ]
        }
    ]
}
EOF
}
