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

resource "aws_iam_user" "autoglue" {
  provider = aws.clientaccount
  name     = random_uuid.autoglue_aws_iam_user.result

  tags = {
    Name = "route53-autoglue"
  }
}

resource "aws_iam_user_policy_attachment" "autoglue" {
  provider   = aws.clientaccount
  user       = aws_iam_user.autoglue.name
  policy_arn = aws_iam_policy.route53_autoglue.arn
  depends_on = [aws_iam_user.autoglue]
}

resource "aws_iam_access_key" "autoglue" {
  provider   = aws.clientaccount
  user       = aws_iam_user.autoglue.name
  depends_on = [aws_iam_user.autoglue]
}

resource "random_uuid" "autoglue_aws_iam_user" {
}

resource "autoglue_credential" "route53" {
  name                = "${var.tenant_key}-route53-autoglue-credentials"
  credential_provider = "aws"
  kind                = "aws_access_key"

  schema_version = "1"

  scope = {
    service = "route53"
  }

  scope_version = 1
  scope_kind    = "service"

  secret = {
    access_key_id     = aws_iam_access_key.autoglue.id
    secret_access_key = aws_iam_access_key.autoglue.secret
  }

}
