resource "aws_launch_template" "fsb_launch_template" {
  name_prefix   = "fsbLT"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = data.aws_ec2_instance_type.t2_micro.id
  vpc_security_group_ids = [aws_security_group.My_sg.id]

  # Other launch template configurations...

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    yum install -y git
    cd /var/www/html
    git clone https://github.com/gabrielecirulli/2048.git
    cd 2048
    mv * ../
    cd ..
    rm -rf 2048
    systemctl restart httpd
    EOF
  )
}

# Create ASG
resource "aws_autoscaling_group" "fsb_asg" {
  name                      = "fsb-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  launch_template {
    id      = aws_launch_template.fsb_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.terraform_remote_state.level1.outputs.private_subnet_id
  target_group_arns   = [aws_lb_target_group.TG.arn]
  tag {
    key                 = "Name"
    value               = "${var.env_code}-fsb_asg"
    propagate_at_launch = true
  }
}
