variable "name" {
  description = "Name of the RDS instance"
  type        = string
}

variable "db_password" {
  description = "RDS admin user password"
  sensitive   = true
}

variable "db_username" {
  description = "RDS user name"
  sensitive   = true
}

variable "db_name" {
  description = "Initial database to create"
}

variable "db_instance_class" {
  description = "RDS instance class"
}

variable "db_security_groups" {
  description = "RDS security groups"
}

variable "db_subnet_ids" {
  description = "VPC subnet ids for RDS instance"
}

