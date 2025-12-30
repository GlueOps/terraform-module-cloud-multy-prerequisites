resource "aws_iam_policy" "route53_autoglue" {

  provider = aws.clientaccount
  name     = random_uuid.route53_autoglue_aws_iam_policy.result
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": "*"
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
    Name = "route53-autoglue"
  }
}

resource "random_uuid" "route53_autoglue_aws_iam_policy" {
}
