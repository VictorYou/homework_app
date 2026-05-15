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

  subnet_ids = [
    "subnet-0f33e3ea62752f61e",
    "subnet-0a589de5d3123fe0a"
  ]
}

resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "Allow PostgreSQL"

  vpc_id = "vpc-0fe862b1e74c2b8d3"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
