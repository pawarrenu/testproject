# ssl_dns.tf

resource "aws_acm_certificate" "self_signed_cert" {
  domain_name       = "test.example.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "self_signed_cert_validation" {
  certificate_arn = aws_acm_certificate.self_signed_cert.arn
}

resource "aws_route53_zone" "private_zone" {
  name         = "example.com"
  vpc {
    vpc_id     = aws_vpc.test_vpc.id
    vpc_region = "us-east-1"
  }
}

resource "aws_route53_record" "test_example_com" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "test.example.com"
  type    = "A"
  ttl     = "300"
  records = [aws_lb.web_lb.dns_name]
}
