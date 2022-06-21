#
# Create ECS resources
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
    key     = "service/service-terraform.tfstate"
    region  = "eu-north-1"
  }
}

# Retrieve private subnets
data "aws_subnets" "private" {
  tags = {
    Name = "${var.name}-private-subnet-*"
  }
}

# Retrieve a security group created for the task
data "aws_security_groups" "ecs-tasks" {
  filter {
    name = "group-name"
    values = ["${var.name}-sg-tasks"]
  }
}

# Retrieve a target group created for the task at ALB
data "aws_lb_target_group" "alb-tg" {
  name = "${var.name}-tg"
}

# Create ECS resources
module "ecs" {
  source                      = "../modules/ecs"
  name                        = var.name
  region                      = var.aws-region
  subnets                     = data.aws_subnets.private.ids
  aws_alb_target_group_arn    = data.aws_lb_target_group.alb-tg.arn
  service_security_groups     = data.aws_security_groups.ecs-tasks.ids
  container_name              = "${var.name}-nginx"
  nginx_port                  = var.nginx_port
  nginx_cpu                   = var.nginx_cpu
  nginx_memory                = var.nginx_memory
  nginx_image                 = var.nginx_image
  nginx_image_tag             = var.nginx_image_tag
  service_desired_count       = var.service_desired_count
}

