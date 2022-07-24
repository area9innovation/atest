variable "region" {
  description = "the region where all the machines will be at"
  type        = string
  default     = "us-east-1"
}
variable "machine-name" {
  description = "the name that will be given to the machines"
  type        = string
  default     = "ec2"
}
variable "vpc-name" {
  description = "the name that will be given to the vpc"
  type        = string
  default     = "vpc-area9"
}
variable "sg-name" {
  description = "the name that will be given to the security group"
  type        = string
  default     = "sgarea9"
}
variable "pg-name" {
  description = "the name that will be given to the placment group"
  type        = string
  default     = "sg-area9"
}
variable "alb_name" {
   type = string
   default = "area9-lb"
}
variable "health_check" {
   type = map(string)
   default = {
      "timeout"  = "10"
      "interval" = "20"
      "path"     = "/"
      "port"     = "80"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
    }
}
variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  default = "Just4trial1999"
}