# Terraform AWS VPC Project

This Leanrning project provisions an AWS Virtual Private Cloud (VPC) along with two subnets using Terraform. 

## Prerequisites

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with appropriate credentials

## Project Structure

```
terraform-aws-vpc
├── main.tf          # Main configuration for VPC and subnets
├── providers.tf     # Provider configuration for AWS
├── terraform.tfvars # Variable definitions for the project
└── README.md        # Documentation for the project
```

## Getting Started

1. **Clone the repository** :
   ```
   git clone <repository-url>
   cd terraform-aws-vpc
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:
   ```
   terraform init
   ```

3. **Review the configuration**:
   You can see the planned actions by running:
   ```
   terraform plan
   ```

4. **Apply the configuration**:
   To create the resources defined in the configuration, run:
   ```
   terraform apply -var-file terraform.tfvars
   ```

5. **Destroy the resources**:
   If you want to remove the resources created by Terraform, run:
   ```
   terraform destroy
   ```

## Variables

The `terraform.tfvars` file contains variable definitions that can be modified to customize the VPC and subnets:
example : 
vpc_cidr = "10.0.0.0/16"
subnet_a_cidr = "10.0.1.0/24"
subnet_b_cidr = "10.0.2.0/24"
availability_zone_a =  "us-east-1a"
availability_zone_b = "us-east-1b"
aws_region = "us-east-1"
environment = "dev"

