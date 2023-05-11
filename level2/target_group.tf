#TG Creation1
resource "aws_lb_target_group" "TG" {
  name_prefix = "FsbTG"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

#TG Association1
resource "aws_lb_target_group_attachment" "instance_1_attachment" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.fsb_server[0].id
  port             = 80
}

#TG Association2
resource "aws_lb_target_group_attachment" "instance_2_attachment" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.fsb_server[1].id
  port             = 80
}
