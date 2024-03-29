# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "enable_sns_topic" {
  type        = bool
  description = "A boolean value to alter deployment of an SNS topic for CloudWatch actions"
  default     = false
}

# ------------------------------------------------------------------------------
# NFS Variables
# ------------------------------------------------------------------------------

variable "nfs_server" {
  type        = string
  description = "The name or IP of the environment specific NFS server"
  default     = null
}

variable "nfs_mount_destination_parent_dir" {
  type        = string
  description = "The parent folder that all NFS shares should be mounted inside on the EC2 instance"
  default     = null
}

variable "nfs_mounts" {
  type        = map(any)
  description = "A map of objects which contains mount details for each mount path required."
  default     = null
  # EXAMPLE
  # default = {
  #   SH_NFSTest = {                  # The name of the NFS Share from the NFS Server
  #     local_mount_point = "folder", # The name of the local folder to mount to if the share name is not wanted
  #     mount_options = [             # Traditional mount options as documented for any NFS Share mounts
  #       "rw",
  #       "wsize=8192"
  #     ]
  #   }
  # }
}

# ------------------------------------------------------------------------------
# CEU Frontend Variables - ALB 
# ------------------------------------------------------------------------------
variable "fe_service_port" {
  type        = number
  default     = 80
  description = "Target group backend port"
}

variable "fe_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

variable "fe_default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "fe_nlb_static_addressing" {
  type        = bool
  default     = false
  description = "Controls whether to define static IP addressing through the use of an NLB (true) or use the default dynamic addressing (false)"
}

variable "fe_app_release_version" {
  type        = string
  description = "Version of the application to download for deployment to frontend server(s)"
}

variable "fe_ami_name" {
  type        = string
  default     = "ceu-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for frontend server(s)"
}

variable "fe_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "fe_min_size" {
  type        = number
  description = "The min size of the ASG"
}

variable "fe_max_size" {
  type        = number
  description = "The max size of the ASG"
}

variable "fe_desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "fe_cw_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}
