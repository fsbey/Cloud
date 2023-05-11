locals {
  public_cidr = ["168.150.1.0/24", "168.150.2.0/24"]
}

# Create security group for ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

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
  subnets            = data.terraform_remote_state.level1.outputs.public_subnet_id

  security_groups = [aws_security_group.alb_sg.id]
}

# Create listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}
