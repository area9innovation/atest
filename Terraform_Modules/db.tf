resource "aws_db_instance" "db" {
        instance_class     = "db.t2.micro"
        identifier = "mysqldatabase"
        storage_type = "gp2"
        allocated_storage = 20
        engine = "mysql"
        port = "3306"
        name = "Area9DB"
        username = var.username
        db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
        password = var.password
        publicly_accessible = false
        deletion_protection = true
        skip_final_snapshot = false
        tags = {
                Name = "Area9 MySql RDS Instance"
        }
}
