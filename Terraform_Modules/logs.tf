# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "area9_log_group" {
  name              = "/ecs/area9"
  retention_in_days = 30

  tags = {
    Name = "cb-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "area9_log_stream" {
  name           = "area9-log-stream"
  log_group_name = aws_cloudwatch_log_group.area9_log_group.name
}
