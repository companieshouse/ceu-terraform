# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  accountIds   = data.vault_generic_secret.account_ids.data
  admin_cidrs  = values(data.vault_generic_secret.internal_cidrs.data)
  s3_releases  = data.vault_generic_secret.s3_releases.data
  ceu_rds_data = data.vault_generic_secret.ceu_rds.data
  ceu_bep_data = data.vault_generic_secret.ceu_bep_data.data_json
  ceu_ec2_data = data.vault_generic_secret.ceu_ec2_data.data

  dba_dev_cidrs_list = jsondecode(data.vault_generic_secret.ceu_rds.data_json)["dba-dev-cidrs"]

  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  account_ssm_key_arn    = local.kms_keys_data["ssm"]
  logs_kms_key_id        = local.kms_keys_data["logs"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  rds_ingress_cidrs = concat(local.admin_cidrs, var.rds_onpremise_access)

  ceu_fe_subnet_cidrs = jsondecode(data.vault_generic_secret.ceu_fe_outputs.data["ceu-frontend-web-subnets-cidrs"])

  bep_cw_logs    = { for log, map in var.bep_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-bep-${log}" }) }
  bep_log_groups = compact([for log, map in local.bep_cw_logs : lookup(map, "log_group_name", "")])

  ceu_bep_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    heritage_environment       = var.environment
    version                    = var.bep_app_release_version
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    region                     = var.aws_region
    cw_log_files               = local.bep_cw_logs
    cw_agent_user              = "root"
  }

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }

  parameter_store_path_prefix = "/${var.application}/${var.environment}"
  
  parameter_store_secrets = {
    backend_inputs          = local.ceu_bep_data
    backend_ansible_inputs  = jsonencode(local.ceu_bep_ansible_inputs)
    backend_cron_entries    = data.template_file.ceu_cron_file.rendered
  }
}
