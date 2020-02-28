resource "aws_alb_target_group" "nginx_alb_tg" {
  name        = "nginx-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main_vpc.id
  health_check {
    port                = 80
    protocol            = "HTTP"
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

/*
resource "aws_alb_target_group_attachment" "alb_tg_at" {
  target_group_arn = aws_alb_target_group.nginx_alb_tg.arn
  target_id        = 
  port             = 80
}
*/

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.external-k8s-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nginx_alb_tg.arn
    type             = "forward"
  }
}

resource "aws_alb" "external-k8s-lb" {
  name               = "external-k8s-lb"
  subnets            = [aws_subnet.vlan1.id, aws_subnet.vlan2.id]
  security_groups    = [aws_security_group.alb_sg.id]
  internal           = false
  load_balancer_type = "application"
  access_logs {
    bucket = "a-khalilau-terraform"
    prefix = "logs"
  }
}