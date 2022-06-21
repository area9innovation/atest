resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.nginx_cpu
  memory                   = var.nginx_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name      = var.container_name
    image     = "${var.nginx_image}:${var.nginx_image_tag}"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.nginx_port
      hostPort      = var.nginx_port
    }]
  }])

  tags = {
    Name = "${var.name}-nginx-task"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"

  tags = {
    Name = "${var.name}-cluster"
  }
}

resource aws_ecs_cluster_capacity_providers "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "this" {
  name                              = "${var.name}-service"
  cluster                           = aws_ecs_cluster.this.id
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = var.service_desired_count
  health_check_grace_period_seconds = 60
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"

  network_configuration {
    security_groups  = var.service_security_groups
    subnets          = var.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.nginx_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

