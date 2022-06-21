variable "name" {
  description = "Name of the stack"
}

variable "aws-region" {
  description = "AWS region"
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
}

variable "nginx_port" {
  description = "Exposed port of the container"
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

