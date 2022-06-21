output "db_hostname" {
  description = "DB instance hostname"
  value       = aws_db_instance.atest.address
}

output "db_port" {
  description = "DB instance port"
  value       = aws_db_instance.atest.port
}

