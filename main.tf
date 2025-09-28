provider "aws" {}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
 }
variable "subnet_a_cidr" {
  description = "The CIDR block for Subnet A"
}
variable "env_prefix" {
  description = "The environment for tagging resources"
}
variable "my_ip" {
  description = "Your IP address for SSH access"
}
variable "avail_zone" {
  description = "The availability zone for the resources"
}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "myapp-vpc"
    environment = "dev"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = var.avail_zone
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-main-rtb"
  }
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-default-sg"
  }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name" 
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws-ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2-public_ip" {
  value = aws_instance.myapp-server.public_ip
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")
  
  user_data_replace_on_change = true

  tags = {
    Name: "${var.env_prefix}-server"
  }
}
variable "public_key_location" {
  description = "Path to the public key for SSH access"
  default = "~/.ssh/id_rsa.pub"
}
variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro"
}