resource "aws_acm_certificate" "main" {
  domain_name       = "hacphan.com"
  validation_method = "DNS"

  tags = {
    environment = local.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm" {
  name    = aws_acm_certificate.main.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.main.id
  records = [ aws_acm_certificate.main.domain_validation_options.0.resource_record_value ]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [ aws_route53_record.acm.fqdn ]
}
