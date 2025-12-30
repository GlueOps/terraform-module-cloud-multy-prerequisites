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