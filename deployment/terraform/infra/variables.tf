variable "name" {
  description = "Name of the stack"
}

variable "aws-region" {
  description = "AWS region"
}

variable "cidr" {
  description = "CIDR block for VPC"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "private_subnets" {
  description = "List of CIDRs for private subnets in VPC"
}

variable "public_subnets" {
  description = "List of CIDRs for public subnets in VPC"
}

variable "db_port" {
  description = "RDS instance port"
}

variable "health_check_path" {
  description = "Path for health checking the container"
}
variable "nginx_port" {
  description = "Exposed port of the container"
}

