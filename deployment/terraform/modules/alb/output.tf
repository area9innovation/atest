output "aws_alb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "aws_alb_dns_name" {
  value = aws_lb.this.dns_name
}
