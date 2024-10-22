resource "aws_alb_target_group" "webapp" {
  name     = "${local.env_name}-webapp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  deregistration_delay = 5

  health_check {
    path                = "/api/health"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "identity" {
  name     = "${local.env_name}-identity"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  deregistration_delay = 5

  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "ticketing" {
  name     = "${local.env_name}-ticketing"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  deregistration_delay = 5

  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "activity" {
  name     = "${local.env_name}-activity"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  deregistration_delay = 5

  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "coding" {
  name     = "${local.env_name}-coding"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  deregistration_delay = 5

  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "rabbitmq" {
  name     = "${local.env_name}-rabbitmq"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}
