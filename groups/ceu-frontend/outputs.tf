output "ceu_frontend_address_internal" {
  value = aws_route53_record.ceu_alb_internal.fqdn
}

resource "vault_generic_secret" "asg_web_subnet_cidrs" {
  path = "applications/${var.aws_profile}/${var.application}/ceu-fe-outputs"

  data_json = jsonencode({
    ceu-frontend-web-subnets-cidrs = [for sub in data.aws_subnet.web : sub.cidr_block]
  })
}