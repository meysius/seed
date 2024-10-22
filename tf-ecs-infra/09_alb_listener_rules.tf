resource "aws_alb_listener_rule" "webapp" {
  listener_arn = aws_alb_listener.https.arn
  depends_on   = [aws_alb_target_group.webapp]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.webapp.arn
  }

  condition {
    host_header {
      values = ["${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}"]
    }
  }
}

resource "aws_alb_listener_rule" "identity" {
  listener_arn = aws_alb_listener.https.arn
  depends_on   = [aws_alb_target_group.identity]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.identity.arn
  }

  condition {
    host_header {
      values = ["identity${local.subdomain_suffix}.${local.domain}"]
    }
  }
}

resource "aws_alb_listener_rule" "ticketing" {
  listener_arn = aws_alb_listener.https.arn
  depends_on   = [aws_alb_target_group.ticketing]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ticketing.arn
  }

  condition {
    host_header {
      values = ["ticketing${local.subdomain_suffix}.${local.domain}"]
    }
  }
}
resource "aws_alb_listener_rule" "activity" {
  listener_arn = aws_alb_listener.https.arn
  depends_on   = [aws_alb_target_group.activity]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.activity.arn
  }
  condition {
    host_header {
      values = ["activity${local.subdomain_suffix}.${local.domain}"]
    }
  }
}

resource "aws_alb_listener_rule" "coding" {
  listener_arn = aws_alb_listener.https.arn
  depends_on   = [aws_alb_target_group.coding]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.coding.arn
  }
  condition {
    host_header {
      values = ["coding${local.subdomain_suffix}.${local.domain}"]
    }
  }
}

resource "aws_alb_listener_rule" "rabbitmq" {
  listener_arn = aws_alb_listener.https.arn
  depends_on   = [aws_alb_target_group.rabbitmq]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.rabbitmq.arn
  }
  condition {
    host_header {
      values = ["rabbitmq${local.subdomain_suffix}.${local.domain}"]
    }
  }
}
