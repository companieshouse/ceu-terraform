data "aws_network_interface" "ceu_internal_nlb" {
  for_each = {
    for key, subnet in data.aws_subnet_ids.web.ids : key => subnet
    if var.fe_nlb_static_addressing
  }

  filter {
    name   = "description"
    values = ["ELB ${module.ceu_internal_nlb[0].this_lb_arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

module "ceu_internal_nlb" {
  count = var.fe_nlb_static_addressing ? 1 : 0

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "nlb-${var.application}-fe-internal-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "network"
  enable_deletion_protection = true

  subnet_mapping  = local.ceu_fe_nlb_subnet_mapping_list

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 1
    }
  ]

  target_groups = [
    {
      name                 = "tg-${var.application}-fe-internal-alb-001"
      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "alb"
      targets = [
        {
          target_id        = module.ceu_internal_alb.this_lb_arn
          port             = 80
        }
      ]
      health_check = {
        enabled             = true
        interval            = 30
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "HTTP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
    {
      name                 = "tg-${var.application}-fe-internal-alb-002"
      backend_protocol     = "TCP"
      backend_port         = 443
      target_type          = "alb"
      targets = [
        {
          target_id        = module.ceu_internal_alb.this_lb_arn
          port             = 443
        }
      ]
      health_check = {
        enabled             = true
        interval            = 30
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "HTTP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    }
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}
