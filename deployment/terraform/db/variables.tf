variable "name" {
  description = "Name of the stack"
}

variable "aws-region" {
  type        = string
  description = "AWS region"
}

variable "db_port" {
  description = "RDS instance port"
}

variable "db_username" {
  description = "RDS user name"
  sensitive = true
}

variable "db_name" {
  description = "Name of an initial database to be created"
}

variable "db_password" {
  description = "RDS password"
  sensitive = true
}

variable "db_instance_class" {
  description = "RDSinstance class" 
}
