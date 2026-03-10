resource "aws_route53_record" "ceu_alb_internal" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = var.application
  type    = "A"

  alias {
    name                   = var.fe_nlb_static_addressing ? module.ceu_internal_nlb[0].lb_dns_name : module.ceu_internal_alb.lb_dns_name
    zone_id                = var.fe_nlb_static_addressing ? module.ceu_internal_nlb[0].lb_zone_id : module.ceu_internal_alb.lb_zone_id
    evaluate_target_health = true
  }
}
