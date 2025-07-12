data "aws_ami" "ubuntu_lts" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu-*lts-*"]
  }
}