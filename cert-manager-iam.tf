resource "aws_iam_user" "externaldns" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "externaldns-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_policy" "externaldns" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "externaldns-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:GetChange"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${aws_route53_zone.clusters[each.key].zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_user_policy_attachment" "externaldns" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.externaldns
  user       = each.value.name
  policy_arn = aws_iam_policy.externaldns[each.key].arn
}

resource "aws_iam_access_key" "externaldns" {
  for_each = aws_iam_user.externaldns
  provider = aws.clientaccount
  user     = each.value.name
}

output "externaldns_iam_credentials" {
  value = { for user, keys in aws_iam_access_key.externaldns : user => keys }
}
