resource "aws_resourcegroups_group" "rg_ceu" {
  name        = "rg-${var.application}-ec2"
  description = "Resource Group for ${var.application} application for EC2 Instances"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Application",
      "Values": ["${var.application}"]
    }
  ]
}
JSON
  }
  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}