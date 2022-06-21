output "id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
