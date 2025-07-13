# resource "aws_instance" "ansible_control" {

#   ami           = data.aws_ami.ubuntu_lts.id
#   instance_type = "t3.micro" # t2.micro free-tier
#   credit_specification {
#     cpu_credits = "standard"
#   }
#   metadata_options {
#     http_tokens = "required"
#   }
#   tags = {
#     name = "ansible_control_server"
#   }
# }
resource "aws_instance" "web_server" {
  count = local.server_amount

  ami           = data.aws_ami.ubuntu_lts.id
  instance_type = "t3.micro" # t2.micro free-tier
  key_name      = aws_key_pair.ansible_connection.key_name
  subnet_id     = data.aws_subnets.main_vpc.ids["${count.index}"]

  credit_specification {
    cpu_credits = "standard"
  }
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "web_server_${count.index}"
    role = "web"
  }
  vpc_security_group_ids = [aws_security_group.mgmt.id, aws_security_group.web_server.id, aws_security_group.internet.id]
}

resource "aws_instance" "db_server" {

  ami           = data.aws_ami.ubuntu_lts.id
  instance_type = "t3.micro" # t2.micro free-tier
  key_name      = aws_key_pair.ansible_connection.key_name
  subnet_id     = data.aws_subnets.main_vpc.ids[2]

  credit_specification {
    cpu_credits = "standard"
  }
  metadata_options {
    http_tokens = "required"
  }

  vpc_security_group_ids = [aws_security_group.mgmt.id, aws_security_group.db.id, aws_security_group.internet.id]
  tags = {
    Name = "db_server"
    role = "db"
  }
}

resource "aws_key_pair" "ansible_connection" {
  key_name   = "ansible-key"
  public_key = local.ansible_ssh_public_key

}
