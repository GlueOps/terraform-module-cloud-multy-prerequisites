resource "aws_iam_policy" "route53_autoglue" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = random_uuid.route53_autoglue_aws_iam_policy[each.key].result
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${aws_route53_zone.clusters[each.key].zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName",
        "route53:GetChange",
        "route53:GetHostedZone"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
  tags = {
    Name = "route53-autoglue-${aws_route53_zone.clusters[each.key].name}"
  }
}

resource "random_uuid" "route53_autoglue_aws_iam_policy" {
  for_each = aws_route53_zone.clusters
}
