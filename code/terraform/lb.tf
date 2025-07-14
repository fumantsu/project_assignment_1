resource "aws_lb" "web" {
  name               = "web-server-lb"
  load_balancer_type = "application"
  subnets            = [data.aws_subnets.main_vpc.ids[0], data.aws_subnets.main_vpc.ids[1]]
  security_groups    = [aws_security_group.lb.id]
  tags = {
    name = "webservers-lb"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
  tags = {
    name = "webservers-http-listener"
  }
}


resource "aws_lb_target_group" "web_target_group" {
  name                          = "web-servers-target-group"
  port                          = 80
  protocol                      = "HTTP"
  load_balancing_algorithm_type = "round_robin"
  vpc_id                        = local.vpc_id
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  tags = {
    name = "webservers-target-group"
  }
}

resource "aws_lb_target_group_attachment" "web_servers" {
  count            = local.server_amount
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.web_server[count.index].id
}
