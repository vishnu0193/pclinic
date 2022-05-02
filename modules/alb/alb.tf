resource "aws_lb" "web-app" {
  name               = "web-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false


  tags = {
    Environment = "test"
  }

}
resource "aws_lb_target_group" "app" {
  name     = "web-app-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-app.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

