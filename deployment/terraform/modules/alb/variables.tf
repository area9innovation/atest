variable "name" {
  description = "Name of the stack"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "vpc_id" {
  description = "VPC Id"
}

variable "alb_security_groups" {
  description = "List of security groups"
}

variable "health_check_path" {
  description = "Path for a health check"
}

