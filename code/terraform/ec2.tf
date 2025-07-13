resource "aws_instance" "web_server" {
  count = local.server_amount

  ami           = data.aws_ami.ubuntu_lts.id
  instance_type = "t3.micro" # t2.micro free-tier
  credit_specification {
    cpu_credits = "standard"
  }
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    name = "web_server_${count.index}"
  }
}

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

  referenced_security_group_id = aws_vpc_security_group_egress_rule.web_server_out_db.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

# resource "aws_lb" "web" {
#   name               = "web-server-lb"
#   load_balancer_type = "application"

#   tags = {
#     name = "web-server-lb"
#   }
# }

# resource "aws_lb_listener" "web_listener" {
#   load_balancer_arn = aws_lb.web.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"
#   }
#   tags = {
#     name = "webservers-http-listener"
#   }
# }

# resource "aws_lb_target_group" "web_target_group" {
#   name                          = "web-servers-target-group"
#   port                          = 80
#   protocol                      = "HTTP"
#   load_balancing_algorithm_type = "round-robin"
#   #   stickiness {
#   #     enabled = true
#   #     type = lb_cookie
#   #   }
#   tags = {
#     name = "webservers-target-group"
#   }
# }