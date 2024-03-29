
# DB - Security Group
resource "aws_security_group" "DB_security_group" {
  name = "mydb1"

  description = "RDS postgres server"
  vpc_id = aws_vpc.threetier_vpc.id

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.APP_instance_sg.id]
  } 
  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB - Subnet Group
resource "aws_db_subnet_group" "DB_subnet" {
  name       = "db-subnet"
  subnet_ids = [for value in aws_subnet.DB_Priv_Subnet: value.id]

  tags = {
    Name = "My DB subnet group"
  }
}


# DB - RDS Instance
resource "aws_db_instance" "DB_postgres" {
  allocated_storage        = 20 # gigabytes
  backup_retention_period  = 7   # in days
  db_subnet_group_name     = aws_db_subnet_group.DB_subnet.name
  engine                   = "postgres"
  engine_version           = "12.4"
  identifier               = "dbpostgres"
  instance_class           = "db.t3.micro"
  multi_az                 = false
  name                     = "dbpostgres"
  username                 = "dbadmin"
  password                 = "Tech_challenge_$123"
  port                     = 5432
  publicly_accessible      = false
  storage_encrypted        = true
  storage_type             = "gp2"
  vpc_security_group_ids   = [aws_security_group.DB_security_group.id]
  skip_final_snapshot      = true
}

