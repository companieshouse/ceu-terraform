resource "aws_route53_record" "ceu_rds" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}db"
  type    = "CNAME"
  ttl     = "300"
  records = [module.ceu_rds.this_db_instance_address]
}