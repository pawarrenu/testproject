resource "aws_lb" "web_lb" {
  name               = "web-lb-asg"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg_for_elb.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_1a.id]
  depends_on         = [aws_internet_gateway.web_gw]
}

resource "aws_lb_target_group" "web_alb_tg" {
  name     = "web-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id
}

resource "aws_lb_listener" "web_front_end" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}
