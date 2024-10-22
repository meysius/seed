resource "aws_ses_domain_identity" "identity" {
  domain = local.ses_identity_domain
}

resource "aws_ses_domain_identity_verification" "identity_verification" {
  domain = aws_ses_domain_identity.identity.id

  depends_on = [aws_route53_record.ses_domain_verification]
}

resource "aws_ses_domain_mail_from" "mail_from" {
  domain           = aws_ses_domain_identity.identity.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.identity.domain}"
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = aws_ses_domain_identity.identity.domain
}
