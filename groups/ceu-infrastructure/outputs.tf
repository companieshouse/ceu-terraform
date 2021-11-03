output "rds_address" {
  value = aws_route53_record.ceu_rds.fqdn
}

output "rds_endpoint" {
  value = module.ceu_rds.this_db_instance_address
}

output "rds_database_name" {
  value = module.ceu_rds.this_db_instance_name
}

output "ceu_bep_address_internal" {
  value = aws_route53_record.nlb_backend.fqdn
}
