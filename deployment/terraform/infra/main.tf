#
# Create the necessary infrastructure to be used 
# by a RDS and ECS resources
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
    key     = "infra/infra-terraform.tfstate"
    region  = "eu-north-1"
  }
}

# Create VPC and its elements
module "vpc" {
  source             = "../modules/vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

# Create all necessary security groups for RDS, ECS service and ALB
module "security_groups" {
  source         = "../modules/security-groups"
  name           = var.name
  vpc_id         = module.vpc.id
  vpc_cidr       = var.cidr
  nginx_port     = var.nginx_port
  db_port        = var.db_port
}

# Create an ALB on public subnets
module "alb" {
  source              = "../modules/alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  alb_security_groups = [module.security_groups.alb]
  health_check_path   = var.health_check_path
}

