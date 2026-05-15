resource "aws_db_instance" "postgres" {
  identifier             = "poc-postgres"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t4g.micro"

  allocated_storage      = 20
  storage_type           = "gp3"

  db_name                = "appdb"
  username               = "appuser"
  password               = "ChangeMe123!"

  publicly_accessible    = true
  skip_final_snapshot    = true
  deletion_protection    = false

  multi_az               = false

  backup_retention_period = 0

  auto_minor_version_upgrade = true

  vpc_security_group_ids = [aws_security_group.postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
}

resource "aws_db_subnet_group" "postgres" {
  name = "postgres-subnet-group"

  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "Allow PostgreSQL"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.inbound_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
