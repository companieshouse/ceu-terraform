# ------------------------------------------------------------------------------
# RDS Security Group and rules
# ------------------------------------------------------------------------------
module "ceu_rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "sgr-${var.application}-rds-001"
  description = "Security group for the ${var.application} rds database"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_with_cidr_blocks = [
    {
      from_port   = "1521"
      to_port     = "1521"
      protocol    = "tcp"
      description = "Frontend CEU"
      cidr_blocks = join(",", local.ceu_fe_subnet_cidrs)
    }
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = "1521"
      to_port                  = "1521"
      protocol                 = "tcp"
      description              = "Frontend Tuxedo"
      source_security_group_id = data.aws_security_group.tuxedo.id
    },
    {
      from_port                = "1521"
      to_port                  = "1521"
      protocol                 = "tcp"
      description              = "Backend CEU"
      source_security_group_id = data.aws_security_group.ceu_bep.id
    },
    {
      from_port                = "1521"
      to_port                  = "1521"
      protocol                 = "tcp"
      description              = "Backend CHD"
      source_security_group_id = data.aws_security_group.chd_bep.id
    },
  ]

  egress_rules = ["all-all"]
}

resource "aws_security_group_rule" "dba_dev_ingress" {
  for_each = toset(local.dba_dev_cidrs_list)

  type              = "ingress"
  from_port         = 1521
  to_port           = 1521
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = module.ceu_rds_security_group.security_group_id
}

resource "aws_security_group_rule" "oracle_access_sgs" {
  for_each = data.aws_security_group.rds_ingress

  type                     = "ingress"
  description              = "Oracle access from ${each.value.id}"
  from_port                = 1521
  to_port                  = 1522
  protocol                 = "tcp"
  source_security_group_id = each.value.id
  security_group_id        = module.ceu_rds_security_group.security_group_id
}

resource "aws_security_group_rule" "concourse_ingress" {
  count = var.rds_concourse_access ? 1 : 0

  description       = "Ingress from Concourse"
  type              = "ingress"
  from_port         = 1521
  to_port           = 1521
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.concourse.id]
  security_group_id = module.ceu_rds_security_group.security_group_id
}

resource "aws_security_group_rule" "admin_ingress_db" {

  description       = "Permit Oracle DB access from admin prefix list"
  type              = "ingress"
  from_port         = 1521
  to_port           = 1521
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.admin.id]
  security_group_id = module.ceu_rds_security_group.security_group_id
}

resource "aws_security_group_rule" "admin_ingress_oem" {

  description       = "Permit Oracle Enterprise Manager access from admin ranges"
  type              = "ingress"
  from_port         = 5500
  to_port           = 5500
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.admin.id]
  security_group_id = module.ceu_rds_security_group.security_group_id
}

# ------------------------------------------------------------------------------
# RDS ceu
# ------------------------------------------------------------------------------
module "ceu_rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.13.1" # Pinned version to ensure updates are a choice, can be upgraded if new features are available and required.

  create_db_parameter_group = "true"
  parameter_group_description = join("-", ["Database parameter group for rds", var.application, var.environment, "001"])
  option_group_description = join("-", ["Option group for rds", var.application, var.environment, "001"])
  create_db_subnet_group    = "true"

  identifier                 = join("-", ["rds", var.application, var.environment, "001"])
  engine                     = "oracle-se2"
  major_engine_version       = var.major_engine_version
  engine_version             = var.engine_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  license_model              = var.license_model
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  multi_az                   = var.multi_az
  storage_encrypted          = true
  kms_key_id                 = data.aws_kms_key.rds.arn

  db_name     = upper(var.application)
  username = local.ceu_rds_data["admin-username"]
  password = local.ceu_rds_data["admin-password"]
  port     = "1521"

  deletion_protection       = true
  maintenance_window        = var.rds_maintenance_window
  backup_window             = var.rds_backup_window
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = "false"
  final_snapshot_identifier_prefix = "${var.application}-final-deletion-snapshot"

  # Enhanced Monitoring
  monitoring_interval             = "30"
  monitoring_role_arn             = data.aws_iam_role.rds_enhanced_monitoring.arn
  enabled_cloudwatch_logs_exports = var.rds_log_exports

  performance_insights_enabled          = var.environment == "live" ? true : false
  performance_insights_kms_key_id       = data.aws_kms_key.rds.arn
  performance_insights_retention_period = 7

  ca_cert_identifier = "rds-ca-rsa2048-g1"

  # RDS Security Group
  vpc_security_group_ids = [
    module.ceu_rds_security_group.security_group_id,
    data.aws_security_group.rds_shared.id
  ]

  # DB subnet group
  subnet_ids = data.aws_subnets.data.ids

  # DB Parameter group
  family = join("-", ["oracle-se2", var.major_engine_version])

  parameters = var.parameter_group_settings

  options = concat([
    {
      option_name                    = "OEM"
      port                           = "5500"
      vpc_security_group_memberships = [module.ceu_rds_security_group.security_group_id]
    }
  ], var.option_group_settings)

  timeouts = {
    "create" : "80m",
    "delete" : "80m",
    "update" : "80m"
  }

  tags = merge(
    local.default_tags,
    {
      ServiceTeam = "${upper(var.application)}-DBA-Support"
    }
  )
}

module "rds_start_stop_schedule" {
  source = "git@github.com:companieshouse/terraform-modules//aws/rds_start_stop_schedule?ref=tags/1.0.354"

  rds_schedule_enable = var.rds_schedule_enable

  rds_instance_id     = module.ceu_rds.db_instance_identifier
  rds_start_schedule  = var.rds_start_schedule
  rds_stop_schedule   = var.rds_stop_schedule
}

module "rds_cloudwatch_alarms" {
  source = "git@github.com:companieshouse/terraform-modules//aws/oracledb_cloudwatch_alarms?ref=tags/1.0.354"

  db_instance_id         = module.ceu_rds.db_instance_identifier
  db_instance_shortname  = upper(var.application)
  alarm_actions_enabled  = var.alarm_actions_enabled
  alarm_name_prefix      = "Oracle RDS"
  alarm_topic_name       = var.alarm_topic_name
  alarm_topic_name_ooh   = var.alarm_topic_name_ooh
}
