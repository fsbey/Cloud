#TG Creation1
resource "aws_lb_target_group" "TG" {
  name_prefix      = "FsbTG"
  target_group_arn = aws_autoscaling_group.fsb_asg.arn
  port             = 80
  protocol         = "HTTP"
  target_type      = "instance"
  vpc_id           = data.terraform_remote_state.level1.outputs.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  depends_on = [aws_autoscaling_group.fsb_asg]

}
