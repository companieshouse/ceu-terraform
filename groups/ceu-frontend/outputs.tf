output "ceu_frontend_address_internal" {
  value = aws_route53_record.ceu_alb_internal.fqdn
}
