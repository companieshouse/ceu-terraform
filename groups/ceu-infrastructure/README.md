# aws-heritage-infrastructure-terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudtrail"></a> [cloudtrail](#module\_cloudtrail) | git@github.com:companieshouse/terraform-modules//aws/cloudtrail?ref=tags/1.0.54 |  |
| <a name="module_config"></a> [config](#module\_config) | git@github.com:companieshouse/terraform-modules//aws/config?ref=tags/1.0.63 |  |
| <a name="module_default_vpc_resources"></a> [default\_vpc\_resources](#module\_default\_vpc\_resources) | git@github.com:companieshouse/terraform-modules//aws/aws_default_resources?ref=tags/1.0.0 |  |
| <a name="module_kms"></a> [kms](#module\_kms) | git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.56 |  |
| <a name="module_kms_rds"></a> [kms\_rds](#module\_kms\_rds) | git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.18 |  |
| <a name="module_nagios_shared_sg"></a> [nagios\_shared\_sg](#module\_nagios\_shared\_sg) | terraform-aws-modules/security-group/aws |  |
| <a name="module_rds_shared_sg"></a> [rds\_shared\_sg](#module\_rds\_shared\_sg) | terraform-aws-modules/security-group/aws |  |
| <a name="module_route53_private_zone"></a> [route53\_private\_zone](#module\_route53\_private\_zone) | git@github.com:companieshouse/terraform-modules//aws/route53_zones?ref=tags/1.0.12 |  |
| <a name="module_route_table"></a> [route\_table](#module\_route\_table) | git@github.com:companieshouse/terraform-modules//aws/route_tables?ref=tags/1.0.13 |  |
| <a name="module_route_table_public"></a> [route\_table\_public](#module\_route\_table\_public) | git@github.com:companieshouse/terraform-modules//aws/route_tables?ref=tags/1.0.13 |  |
| <a name="module_s3_vpc_endpoint"></a> [s3\_vpc\_endpoint](#module\_s3\_vpc\_endpoint) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 3.0.0 |
| <a name="module_subnets"></a> [subnets](#module\_subnets) | git@github.com:companieshouse/terraform-modules//aws/multi_az_subnets?ref=tags/1.0.9 |  |
| <a name="module_transit_gateway_attachment"></a> [transit\_gateway\_attachment](#module\_transit\_gateway\_attachment) | git@github.com:companieshouse/terraform-modules//aws/transit_gateway_attachment?ref=tags/1.0.5 |  |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_config_conformance_pack.pci_dss](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_conformance_pack) | resource |
| [aws_iam_policy.s3_endpoint_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route53_resolver_rule_association.shared_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_ssm_document.session_manager_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [vault_generic_secret.kms](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.route_53](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.transit-gateway_attachment](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.vpc](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [aws_route53_resolver_rules.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_rules) | data source |
| [aws_subnet_ids.attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.transit_gateway](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The shorthand for the AWS account | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The AWS account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_config_primary_region"></a> [config\_primary\_region](#input\_config\_primary\_region) | AWS config has options to collect and apply both regional and global collection, this is used to ensure global objects are only collected in a single region to avoid duplication. | `bool` | `false` | no |
| <a name="input_kms_customer_master_keys"></a> [kms\_customer\_master\_keys](#input\_kms\_customer\_master\_keys) | Map of KMS customer master keys and key policies to be created | `map` | `{}` | no |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | The suffix for the private domain name to be used for route53 zones | `string` | `"aws.internal"` | no |
| <a name="input_region"></a> [region](#input\_region) | The shorthand for the AWS region | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets to create including their new bits count | <pre>list(object({<br>    name     = string<br>    new_bits = number<br>  }))</pre> | `[]` | no |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The network cidr block to be used for the VPC (e.g. 10.0.0.0/16) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->