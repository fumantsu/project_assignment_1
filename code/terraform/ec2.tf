resource "aws_instance" "web_server" {
    count = var.server_amount

    ami = data.aws_ami.ubuntu_lts.id
    instance_type = "t3a.micro" # t2.micro free-tier

  tags={
    name="web_server_${count.index}"
  }
}


resource "aws_lb" "web" {
    name = "web-server-lb"
    load_balancer_type = "application"

    tags = {
      name="web-server-lb"
    } 
}

resource "aws_lb_listener" "web_listener" {
    load_balancer_arn = aws_lb.web.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
    }
    tags = {
        name="webservers-http-listener"
    }
}

resource "aws_lb_target_group" "web_target_group" {
  name = "web-servers-target-group"
  port = 80
  protocol = "HTTP"
  load_balancing_algorithm_type = "round-robin"
#   stickiness {
#     enabled = true
#     type = lb_cookie
#   }
  tags = {
    name = "webservers-target-group"
  }
}