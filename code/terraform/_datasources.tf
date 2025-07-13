data "aws_vpc" "main_vpc" {
  id = local.vpc_id
}
data "aws_ami" "ubuntu_lts" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/*noble*-amd64-server-*"]
  }
}