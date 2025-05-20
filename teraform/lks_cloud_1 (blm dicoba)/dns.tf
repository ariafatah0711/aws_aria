# Ganti dengan domain aslimu yang sudah dibeli
variable "domain_name" {
  default = "ariafatah.my.id"
}

# Ambil Hosted Zone yang sudah ada di Route 53
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# ACM Certificate (region us-west-2)
resource "aws_acm_certificate" "ssl" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  tags = {
    "LKS-CC-2024" = "ACM"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Record otomatis
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

# Tunggu validasi selesai
resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.ssl.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]
}

# Listener HTTPS
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_valid.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Redirect HTTP → HTTPS
resource "aws_lb_listener_rule" "http_redirect" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["modul1.${var.domain_name}"]
    }
  }
}

# DNS A record untuk subdomain "modul1"
resource "aws_route53_record" "app_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "modul1"
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}