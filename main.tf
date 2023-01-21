
provider "aws" {
  version = "4.39.0"
  alias   = "clientaccount"
  region  = local.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.company_account_id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_route53_zone" "main" {
  provider = aws.clientaccount
  name     = "${local.company_key}.${local.domain_to_delegate_from}"
}

resource "aws_route53_zone" "clusters" {
  provider = aws.clientaccount
  for_each = toset(var.cluster_environments)
  name     = "${each.value}.${local.company_key}.${local.domain_to_delegate_from}"
  depends_on = [
    aws_route53_zone.main
  ]
}

resource "aws_route53_record" "cluster_subdomain_ns_records" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = aws_route53_zone.main.zone_id
  name     = each.value.name
  type     = local.ns_record_type
  ttl      = local.ns_record_ttl
  records  = aws_route53_zone.clusters[each.key].name_servers
}


resource "aws_iam_user" "route53" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "route53-${aws_route53_zone.clusters[each.key].name}"
}

resource "aws_iam_policy" "route53" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  name     = "route53-${aws_route53_zone.clusters[each.key].name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:GetChange"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${aws_route53_zone.clusters[each.key].zone_id}"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_user_policy_attachment" "route53" {
  provider   = aws.clientaccount
  for_each   = aws_iam_user.route53
  user       = each.value.name
  policy_arn = aws_iam_policy.route53[each.key].arn
}

resource "aws_iam_access_key" "route53" {
  for_each = aws_iam_user.route53
  provider = aws.clientaccount
  user     = each.value.name
}

output "route53_iam_credentials" {
  value = { for user, keys in aws_iam_access_key.route53 : user => keys }
}
