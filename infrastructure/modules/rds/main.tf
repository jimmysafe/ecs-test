locals {
  name = "${lower(var.project_name)}-${var.environment}"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${local.name}-db-subnet-group"
  subnet_ids = ["${var.subnet_1_id}", "${var.subnet_2_id}"]
  description = "Subnets for database instance"

  tags = {
    "Name" = "${local.name}-db-subnet-group"
  }
}

resource "aws_security_group" "db_security_group" {
  vpc_id      = "${var.vpc_id}"
  name = "${local.name}-db-sg"
  description = "Db Security Group"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.ecs_service_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${local.name}-db-sg"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible = false

  tags = {
    "Name" = "${local.name}-postgres-db"
  }
}