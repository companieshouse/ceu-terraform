data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-data-*"]
  }
}

data "aws_security_group" "rds_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-rds-shared-001*"]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "aws_iam_role" "rds_enhanced_monitoring" {
  name = "irol-rds-enhanced-monitoring"
}

data "aws_kms_key" "rds" {
  key_id = "alias/kms-rds"
}

data "vault_generic_secret" "ceu_rds" {
  path = "applications/${var.aws_profile}/${var.application}/rds"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

#-----------------
# CEU Backend Data
#-----------------
data "aws_ami" "ceu_bep" {
  owners      = [data.vault_generic_secret.account_ids.data["heritage-development"]]
  most_recent = var.bep_ami_name == "ceu-backend-*" ? true : false

  filter {
    name = "name"
    values = [
      var.bep_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "bep_userdata" {
  template = file("${path.module}/templates/bep_user_data.tpl")

  vars = {
    REGION             = var.aws_region
    CEU_BACKEND_INPUTS = local.ceu_bep_data
    ANSIBLE_INPUTS     = jsonencode(local.ceu_bep_ansible_inputs)
    CEU_CRON_ENTRIES   = var.account == "hlive" ? "#No Entries" : templatefile("${path.module}/templates/bep_cron.tpl", { "USER" = "", "PASSWORD" = "" })
  }
}

data "template_cloudinit_config" "bep_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.bep_userdata.rendered
  }
}
