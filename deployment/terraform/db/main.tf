#
# Create RDS database resources
#
terraform {
  required_version = "~> 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}

# Set up terraform state backend
terraform {
  backend "s3" {
    bucket  = "atest-tf-backend-4f3544fd2c4d6"
    key     = "rds/rds-terraform.tfstate"
    region  = "eu-north-1"
  }
}

# Retrieve a security group for the database
data "aws_security_groups" "db-mysql" {
  filter {
    name = "group-name"
    values = ["${var.name}-sg-db-mysql"]
  }
}

# Retrieve private subnets
data "aws_subnets" "private" {
  tags = {
    Name = "${var.name}-private-subnet-*"
  }
}

# Create a RDS instance
module "rds" {
  source                      = "../modules/rds"
  name                        = var.name
  db_password                 = var.db_password
  db_username                 = var.db_username
  db_name                     = var.db_name
  db_instance_class           = var.db_instance_class
  db_security_groups          = data.aws_security_groups.db-mysql.ids
  db_subnet_ids               = data.aws_subnets.private.ids
}

