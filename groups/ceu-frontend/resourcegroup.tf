resource "aws_resourcegroups_group" "rg_ceu" {
  name        = "rg-${var.application}-for-ec2-instances-in-dev-env"
  description = "Resource Group for ${var.application}-application"

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
}