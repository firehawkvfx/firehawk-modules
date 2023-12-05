variable "iam_role_id" {
    type = string
    description = "The ID of the IAM role to attach the policy to."
}
variable "bucket_arns" {
  description = "The ARNs of the S3 bucket where the certificate is stored."
  type        = list(string)
}
variable "region" {
  description = "The region where the certificate is stored."
  type        = string
}
variable "resourcetier" {
  description = "The resourcetier (environment) the desired vault vpc resides in"
  type        = string
}