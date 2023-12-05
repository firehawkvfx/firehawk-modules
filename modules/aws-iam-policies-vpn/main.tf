locals {
  store_crt_secret_lambda_function_name = "store_crt_secret"
  nebula_ca_crt_secret_name             = "/firehawk/resourcetier/${var.resourcetier}/network/render/nebula_ca_crt"
  nebula_config_lambda_function_name    = "nebula_config"
}

data "aws_caller_identity" "current" {}

# TODO this needs to be created as a group, and attached to a role that does this
# aws-iam-policies-vpn
data "aws_iam_policy_document" "nebula_signer" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction" # These lambda funcitons sign crts and generate configs
    ]
    resources = [
      "arn:aws:lambda:*:*:function:${local.store_crt_secret_lambda_function_name}",
      "arn:aws:lambda:*:*:function:${local.nebula_config_lambda_function_name}"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue" # This is where the CA crt is kept for validation.
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${local.nebula_ca_crt_secret_name}",
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${local.nebula_ca_crt_secret_name}-*"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject" # Signed certs are placed in this bucket
    ]
    resources = concat([
      for bucket_arn in var.bucket_arns : "${bucket_arn}"
      ],
      [
        for bucket_arn in var.bucket_arns : "${bucket_arn}/*"
    ])
  }
}

resource "aws_iam_policy" "nebula_signer" {
  name        = "nebula_signer_usage_policy"
  path        = "/"
  description = "IAM policy for querying dynamodb from a lambda"
  policy      = data.aws_iam_policy_document.nebula_signer.json
}

resource "aws_iam_policy_attachment" "nebula_signer" {
  name       = "nebula_signer_usage_policy_attachment"
  policy_arn = aws_iam_policy.nebula_signer.arn
  roles = [
    var.iam_role_id
  ]
}
