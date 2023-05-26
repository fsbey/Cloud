locals {
  public_cidr = ["168.150.1.0/24", "168.150.2.0/24"]
}

data "aws_route53_zone" "hosted_zone" {
  name = "itsguts.com"  # Replace with your domain name
}

# Create security group for ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
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
  certificate_arn = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
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
    timeout             = 20
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

}

resource "aws_route53_record" "my_dns_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "www.${data.aws_route53_zone.hosted_zone.name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.alb.dns_name]
}
