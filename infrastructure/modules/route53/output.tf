
output "output_ssl_certificate_arn" {
    description = "Route53 SSL certificate ARN"
    value = aws_acm_certificate.default.arn
}

