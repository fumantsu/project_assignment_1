resource "aws_security_group" "lb" {
  name   = "lb"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "lb_incoming_http" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = "213.220.234.36/32"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "lb_incoming_https" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = "213.220.234.36/32"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}


resource "aws_vpc_security_group_egress_rule" "to_web_server" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = data.aws_vpc.main_vpc.cidr_block
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
resource "aws_security_group" "web_server" {
  name   = "webserver"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "web_server_incoming" {
  security_group_id = aws_security_group.web_server.id

  referenced_security_group_id = aws_security_group.lb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "web_server_out_db" {
  security_group_id = aws_security_group.web_server.id

  cidr_ipv4   = data.aws_vpc.main_vpc.cidr_block
  from_port   = -1
  ip_protocol = "ALL"
  to_port     = -1
}
resource "aws_security_group" "db" {
  name   = "db"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "db_incoming" {
  security_group_id = aws_security_group.db.id

  referenced_security_group_id = aws_security_group.web_server.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "db_out" {
  security_group_id = aws_security_group.db.id

  cidr_ipv4   = data.aws_vpc.main_vpc.cidr_block
  from_port   = -1
  ip_protocol = "ALL"
  to_port     = -1
}


resource "aws_security_group" "mgmt" {
  name   = "mgmt"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "mgmt" {
  security_group_id = aws_security_group.mgmt.id

  cidr_ipv4   = "213.220.234.36/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


resource "aws_security_group" "internet" {
  name   = "internet"
  vpc_id = local.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "https_internet" {
  security_group_id = aws_security_group.internet.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "http_internet" {
  security_group_id = aws_security_group.internet.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}