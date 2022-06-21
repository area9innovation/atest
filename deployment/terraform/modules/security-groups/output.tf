output "alb" {
  value = aws_security_group.alb.id
}

output "ecs_tasks" {
  value = aws_security_group.ecs_tasks.id
}

output "db_security_groups" {
  value = aws_security_group.db-mysql.id
}
