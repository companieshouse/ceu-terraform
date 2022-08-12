data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-public-*"]
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-web-*"]
  }
}

data "aws_subnet" "web" {
  for_each = data.aws_subnet_ids.web.ids

  id = each.value
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-data-*"]
  }
}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "s3_releases" {
  path = "aws-accounts/shared-services/s3"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "ceu_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/ec2"
}

data "vault_generic_secret" "ceu_fe_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/frontend"
}

data "vault_generic_secret" "ceu_fe_nlb_subnet_mappings" {
  count = var.fe_nlb_static_addressing ? 1 : 0

  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/nlb_subnet_mappings"
}

data "vault_generic_secret" "client_cidrs" {
  count = var.fe_nlb_static_addressing ? 1 : 0

  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/client_cidrs"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
}

# ------------------------------------------------------------------------------
# CEU Frontend data
# ------------------------------------------------------------------------------
data "aws_ami" "ceu_fe" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.fe_ami_name == "ceu-*" ? true : false

  filter {
    name = "name"
    values = [
      var.fe_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "fe_userdata" {
  template = file("${path.module}/templates/fe_user_data.tpl")

  vars = {
    REGION              = var.aws_region
    ENVIRONMENT         = title(var.environment)
    CEU_FRONTEND_INPUTS = local.ceu_fe_data
    ANSIBLE_INPUTS      = jsonencode(local.ceu_fe_ansible_inputs)
  }
}

data "template_cloudinit_config" "fe_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.fe_userdata.rendered
  }
}
