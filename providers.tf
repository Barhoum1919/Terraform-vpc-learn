variable "aws_region" {
  description = "The AWS region to deploy resources in"
}
variable "access_key" {
  description = "The AWS access key"
  sensitive   = true
}

variable "secret_key" {
  description = "The AWS secret key"
  sensitive   = true
}

provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}