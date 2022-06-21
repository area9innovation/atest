output "ecs_cluster" {
  value = aws_ecs_service.this.cluster
}

output "ecs_service_name" {
  value = aws_ecs_service.this.name
}
