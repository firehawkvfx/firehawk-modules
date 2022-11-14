data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
// Configure the terraform-provider-bless
provider "bless" {
  region  = data.aws_region.current.name
  profile = "bless_profile"
#   profile = "<aws_profile>"
}

module "bless" {
  // Replace with latest cztack stable release https://github.com/chanzuckerberg/cztack/releases
  source = "github.com/chanzuckerberg/cztack//bless-ca?ref=v0.49.0"

  project = "firehawk-codepipeline"
  service = "bless"
  env     = "dev"
  owner   = "andrewgr"

  region           = data.aws_region.current.name
  authorized_users = ["andrewgr"]
  aws_account_id   = data.aws_caller_identity.current.account_id
}

module "blessclient" {
  // Replace with latest cztack stable release https://github.com/chanzuckerberg/cztack/releases
  source = "github.com/chanzuckerberg/cztack//aws-iam-role-bless?ref=v0.49.0"

  role_name         = "blessclient"
  source_account_id = data.aws_caller_identity.current.account_id

  bless_lambda_arns = [
    "${module.bless.lambda_arn}",
  ]
}

# Group that authorizes users to invoke bless lambda
module "bless-users" {
  // Replace with latest cztack stable release https://github.com/chanzuckerberg/cztack/releases
  source = "github.com/chanzuckerberg/cztack//aws-iam-group-assume-role?ref=v0.49.0"

  users           = ["andrewgr"]
  group_name      = "bless-users"
  target_accounts = [data.aws_caller_identity.current.account_id]
  target_role     = "${module.blessclient.role_name}"
}