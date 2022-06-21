resource "aws_db_instance" "atest" {
  identifier             = "${var.name}-db-mysql"
  instance_class         = var.db_instance_class
  allocated_storage      = 5
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.atest.name
  vpc_security_group_ids = var.db_security_groups
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  db_name                = var.db_name
  deletion_protection    = false

  tags = {
    Name = "${var.name}-db-mysql"
  }
}

resource "aws_db_subnet_group" "atest" {
  name        = "${var.name}-db-subnetgr"
  subnet_ids  = var.db_subnet_ids

  tags = {
    Name = "${var.name}-db-subnetgr"
  }
}
