variable "name" {
    description = "The name for the policy"
    type = string
    default = "CloudWatchRenderNodeLogging"
}

variable "iam_role_id" {
    description = "The aws_iam_role role id to attach the policy to"
    type = string
}

variable "region" {
  description = "The AWS Region to create all resources in for this module."
  type        = string
  default     = null
}