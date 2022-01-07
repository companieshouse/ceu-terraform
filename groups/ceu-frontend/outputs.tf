output "ceu_frontend_address_internal" {
  value = aws_route53_record.ceu_alb_internal.fqdn
}

resource "vault_generic_secret" "asg_security_group" {
  path = "applications/${var.aws_profile}/${var.application}/ceu-fe-outputs"

  data_json = <<EOT
{
  "ceu-frontend-security-group": "${module.ceu_fe_asg_security_group.this_security_group_id}"
}
EOT
}