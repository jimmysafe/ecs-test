resource "aws_route53_zone" "hzone" {
  name = var.domain
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.hzone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "default" {
  domain_name = "${var.domain}"
  subject_alternative_names = ["*.${var.domain}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# create a record set in route 53 for domain validatation
resource "aws_route53_record" "domain_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hzone.zone_id
}

# validate acm certificates
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation_record : record.fqdn]
}

