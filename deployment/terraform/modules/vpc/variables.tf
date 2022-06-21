variable "name" {
  description = "Name of the stack"
}

variable "cidr" {
  description = "CIDR block for VPC"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}
