variable "resourcetier" {
  description = "The resource tier specifies a unique name for a resource based on the environment.  eg:  dev, green, blue, main."
  type        = string
}

variable "region" {}

variable "vpn_scripts_bucket_name" {
  description = "The name of the S3 bucket where the scripts are stored."
  type        = string
}

variable "vpn_certs_bucket_name" {
  description = "The name of the S3 bucket where the certificates are stored."
  type        = string
}