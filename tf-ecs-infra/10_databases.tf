resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.env_name}-pacely"
  subnet_ids = data.aws_subnets.vpc_subnet_ids.ids
}

resource "aws_db_instance" "database" {
  identifier                = "${local.env_name}-pacely"
  allocated_storage         = local.db_allocated_storage
  max_allocated_storage     = local.db_max_allocated_storage
  deletion_protection       = local.db_deletion_protection
  multi_az                  = local.db_multi_az
  skip_final_snapshot       = local.db_skip_final_snapshot
  final_snapshot_identifier = "${local.env_name}-pacely-final-snapshot"
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "15.5"
  instance_class            = local.db_instance_type
  username                  = var.postgres_user
  password                  = var.postgres_pass
  port                      = var.postgres_port
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.database.id]
}

resource "aws_s3_bucket" "uploads" {
  bucket = "${local.env_name}-pacely-uploads"
}