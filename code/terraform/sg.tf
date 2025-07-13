resource "aws_security_group" "web_server" {
  name   = "web_server_sg"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "web_server_incoming" {
  security_group_id = aws_security_group.web_server.id

  cidr_ipv4   = "0.0.0.0/0" #todo add lb ip
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "web_server_out_db" {
  security_group_id = aws_security_group.web_server.id

  cidr_ipv4   = data.aws_vpc.main_vpc.cidr_block # todo more specific subnet
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432
}
resource "aws_security_group" "db" {
  name   = "db_sg"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "db_incoming" {
  security_group_id = aws_security_group.db.id

  referenced_security_group_id = aws_security_group.web_server.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}
resource "aws_security_group" "mgmt" {
  name   = "sg_mgmt"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "mgmt" {
  security_group_id = aws_security_group.mgmt.id

  cidr_ipv4   = "213.220.234.36/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
