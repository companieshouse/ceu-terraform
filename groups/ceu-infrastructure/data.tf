data "aws_caller_identity" "current" {}

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

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "rds_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-rds-shared-001*"]
  }
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_security_group" "tuxedo" {
  filter {
    name   = "tag:Name"
    values = ["ceu-frontend-tuxedo-${var.environment}"]
  }
}

data "aws_security_group" "ceu_bep" {
  filter {
    name   = "group-name"
    values = ["sgr-ceu-bep-asg*"]
  }
}

data "aws_security_group" "chd_bep" {
  filter {
    name   = "group-name"
    values = ["sgr-chd-bep-asg*"]
  }
}

data "aws_security_group" "rds_ingress" {
  for_each = toset(var.rds_ingress_groups)

  filter {
    name   = "group-name"
    values = [each.value]
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

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "ceu_bep_cron_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/bep-cron"
}

data "vault_generic_secret" "ceu_rds" {
  path = "applications/${var.aws_profile}/${var.application}/rds"
}

data "vault_generic_secret" "s3_releases" {
  path = "aws-accounts/shared-services/s3"
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

data "vault_generic_secret" "ceu_bep_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/backend"
}

data "vault_generic_secret" "ceu_fe_outputs" {
  path = "applications/${var.environment == "live" ? "pci-services-${var.aws_region}" : var.aws_profile}/${var.application}/ceu-fe-outputs"
}

data "aws_ec2_managed_prefix_list" "concourse" {
  name = "shared-services-management-cidrs"
}

data "aws_ec2_managed_prefix_list" "admin" {
  name = "administration-cidr-ranges"
}
#-----------------
# CEU Backend Data
#-----------------
data "aws_ami" "ceu_bep" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
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

data "template_file" "ceu_cron_file" {
  template = file("${path.module}/templates/${var.aws_profile}/bep_cron.tpl")

  vars = {
    USER     = data.vault_generic_secret.ceu_bep_cron_data.data["username"]
    PASSWORD = data.vault_generic_secret.ceu_bep_cron_data.data["password"]
  }
}

data "template_file" "bep_userdata" {
  template = file("${path.module}/templates/bep_user_data.tpl")

  vars = {
    REGION                  = var.aws_region
    HERITAGE_ENVIRONMENT    = title(var.environment)
    APP_VERSION             = var.bep_app_release_version
    CEU_BACKEND_INPUTS_PATH = "${local.parameter_store_path_prefix}/backend_inputs"
    ANSIBLE_INPUTS_PATH     = "${local.parameter_store_path_prefix}/backend_ansible_inputs"
    CEU_CRON_ENTRIES_PATH   = "${local.parameter_store_path_prefix}/backend_cron_entries"
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
