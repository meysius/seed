resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${local.env_name}-pacely"
  subnet_ids = data.aws_subnets.vpc_subnet_ids.ids
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${local.env_name}-pacely"
  final_snapshot_identifier     = "${local.env_name}-pacely-final-snapshot"
  engine                        = "redis"
  node_type                     = local.redis_instance_type
  num_cache_clusters            = 1
  engine_version                = "6.x"
  parameter_group_name          = "default.redis6.x"
  automatic_failover_enabled    = false
  port                          = var.redis_port
  security_group_ids            = [aws_security_group.redis.id]
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  description                   = "Redis cluster"

  lifecycle {
    prevent_destroy = true
  }
}
