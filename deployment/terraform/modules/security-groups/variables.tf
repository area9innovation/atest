variable "name" {
  description = "Name of the stack"
}

variable "vpc_id" {
  description = "VPC Id"
}

variable "nginx_port" {
  description = "Container port"
}

variable "db_port" {
  description = "Port of the RDS instance"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
}
