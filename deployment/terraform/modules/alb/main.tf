resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets.*.id

  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.this.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

