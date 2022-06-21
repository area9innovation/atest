variable "name" {
  description = "Name of the stack"
}

variable "region" {
  description = "AWS region where to create resources"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "service_security_groups" {
  description = "List of security group ids"
}

variable "nginx_port" {
  description = "Port of nginx container"
}

variable "nginx_cpu" {
  description = "Number of cpu units for the task"
}

variable "nginx_memory" {
  description = "Amount (in MiB) of memory for the task"
}

variable "nginx_image" {
  description = "Docker image name"
}

variable "nginx_image_tag" {
  description = "Docker image tag"
}

variable "container_name" {
  description = "Name of a container"
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "service_desired_count" {
  description = "Services to run in parallel"
}

