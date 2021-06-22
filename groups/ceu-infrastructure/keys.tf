# ------------------------------------------------------------------------------
# CEU Key Pair
# ------------------------------------------------------------------------------

resource "aws_key_pair" "ceu_keypair" {
  key_name   = var.application
  public_key = local.ceu_ec2_data["public-key"]
}
