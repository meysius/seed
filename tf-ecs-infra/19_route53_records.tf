data "aws_route53_zone" "domain" {
  name         = local.domain
  private_zone = false
}


resource "aws_route53_record" "app_subdomain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  # name    = "app${local.subdomain_suffix}"
  name    = "${local.subdomain_suffix == "" ? "" : local.subdomain_suffix}"
  type    = "A"

  alias {
    name                   = aws_alb.load_balancer.dns_name
    zone_id                = aws_alb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "identity_subdomain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "identity${local.subdomain_suffix}"
  type    = "A"

  alias {
    name                   = aws_alb.load_balancer.dns_name
    zone_id                = aws_alb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ticketing_subdomain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "ticketing${local.subdomain_suffix}"
  type    = "A"

  alias {
    name                   = aws_alb.load_balancer.dns_name
    zone_id                = aws_alb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "activity_subdomain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "activity${local.subdomain_suffix}"
  type    = "A"

  alias {
    name                   = aws_alb.load_balancer.dns_name
    zone_id                = aws_alb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "coding_subdomain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "coding${local.subdomain_suffix}"
  type    = "A"

  alias {
    name                   = aws_alb.load_balancer.dns_name
    zone_id                = aws_alb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rabbitmq_subdomain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "rabbitmq${local.subdomain_suffix}"
  type    = "A"

  alias {
    name                   = aws_alb.load_balancer.dns_name
    zone_id                = aws_alb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ses_domain_verification" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.identity.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.identity.verification_token]
}

resource "aws_route53_record" "ses_domain_mail_from_mx" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "MX"
  ttl     = "300"
  records = ["10 feedback-smtp.${local.region}.amazonses.com"]
}

resource "aws_route53_record" "ses_domain_mail_from_txt" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "ses_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
