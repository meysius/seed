resource "aws_security_group" "load_balancer" {
  name   = "${local.env_name}-pacely"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name   = "${local.env_name}-pacely-ecs"
  vpc_id = aws_vpc.vpc.id

  # ingress {
  #   description     = "Allow SSH from anywhere"
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }

  ingress {
    description     = "Allow incoming traffic load balancer"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    description = "Allow outgoing traffic to anywhere"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name        = "${local.env_name}-pacely-database"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow ecs instances to access db"
    from_port   = var.postgres_port
    to_port     = var.postgres_port
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
}

resource "aws_security_group" "redis" {
  name        = "${local.env_name}-pacely-redis"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow ecs instances to access redis"
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
}

resource "aws_security_group" "rabbitmq" {
  name        = "${local.env_name}-pacely-rabbitmq"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow incoming traffic load balancer"
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  ingress {
    description = "Allow ecs instances to access rabbitmq"
    from_port   = var.rabbitmq_port
    to_port     = var.rabbitmq_port
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    description = "Allow outgoing traffic to be able to download and install rabbitmq"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
