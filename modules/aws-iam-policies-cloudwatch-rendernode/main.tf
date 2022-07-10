terraform {
  required_version = ">= 0.13.5"
}

resource "aws_iam_role_policy" "cloudwatch_rendernode_logging" {
  name   = var.name
  role   = var.iam_role_id
  policy = data.aws_iam_policy_document.cloudwatch_rendernode_logging.json
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "cloudwatch_rendernode_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:CloudWatchRenderNodeLoggingGroup:*"]
  }
}