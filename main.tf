provider "aws" {}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
 }
variable "subnet_a_cidr" {
  description = "The CIDR block for Subnet A"
}
variable "subnet_b_cidr" {
  description = "The CIDR block for Subnet B"
}
variable "availability_zone_a" {
  description = "The availability zone for Subnet A"
}
variable "availability_zone_b" {
  description = "The availability zone for Subnet B"
}
variable "environment" {
  description = "The environment for tagging resources"
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "dev-vpc"
    environment = "dev"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = var.availability_zone_a
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_b_cidr
  availability_zone = var.availability_zone_b
  tags = {
    Name = "subnet-b"
  }
}