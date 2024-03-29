# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  internal_cidrs = values(data.vault_generic_secret.internal_cidrs.data)
  s3_releases    = data.vault_generic_secret.s3_releases.data
  ceu_ec2_data   = data.vault_generic_secret.ceu_ec2_data.data
  ceu_fe_data    = data.vault_generic_secret.ceu_fe_data.data_json

  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  account_ssm_key_arn    = local.kms_keys_data["ssm"]
  logs_kms_key_id        = local.kms_keys_data["logs"]
  sns_kms_key_id         = local.kms_keys_data["sns"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

  # Conditional because Live is not being deployed to Heritage Live for CEU but rather PCI Services
  internal_fqdn = var.environment == "live" ? "${replace(var.aws_account, "-", "")}.aws.internal" : format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  #For each log map passed, add an extra kv for the log group name
  fe_cw_logs    = { for log, map in var.fe_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-fe-${log}" }) }
  fe_log_groups = compact([for log, map in local.fe_cw_logs : lookup(map, "log_group_name", "")])

  ceu_fe_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    heritage_environment       = var.environment
    version                    = var.fe_app_release_version
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    region                     = var.aws_region
    cw_log_files               = local.fe_cw_logs
    cw_agent_user              = "root"
  }

  ceu_fe_nlb_cidrs = var.fe_nlb_static_addressing ? formatlist("%s/32", [for eni in data.aws_network_interface.ceu_internal_nlb : eni.private_ip]) : []

  ceu_fe_nlb_subnet_mapping_data = var.fe_nlb_static_addressing ? data.vault_generic_secret.ceu_fe_nlb_subnet_mappings[0].data : {}
  ceu_fe_nlb_subnet_mapping_list = var.fe_nlb_static_addressing ? [
    for id in data.aws_subnet_ids.web.ids : {
      subnet_id            = id
      private_ipv4_address = local.ceu_fe_nlb_subnet_mapping_data[id]
    }
   ] : []

  ceu_fe_client_cidrs = var.fe_nlb_static_addressing ? values(data.vault_generic_secret.client_cidrs[0].data) : []

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }

  parameter_store_path_prefix = "/${var.application}/${var.environment}"
  
  parameter_store_secrets = {
    frontend_inputs         = local.ceu_fe_data
    frontend_ansible_inputs = jsonencode(local.ceu_fe_ansible_inputs)
  }
}
