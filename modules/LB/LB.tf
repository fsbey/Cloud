locals {
  public_cidr = ["168.150.1.0/24", "168.150.2.0/24"]
}

# Create security group for ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "my-alb1"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_id
  security_groups = [aws_security_group.alb_sg.id]
}

# Create listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type               = "forward"
    target_group_arn   = aws_lb_target_group.TG.arn
  }
}

#TG Creation1
resource "aws_lb_target_group" "TG" {
  name_prefix = "FsbTG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

}

resource "aws_route53_record" "my_dns_record" {
  zone_id = "Z05599622K22XV64ERVX6"
  name    = "mentorship"
  type    = "CNAME"
  ttl     = 300
  records = ["my-alb1-713027817.us-east-1.elb.amazonaws.com"]
}
