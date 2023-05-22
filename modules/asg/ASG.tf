data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  #Values list contain a wildcard pattern which matches any Amazon Linux 2 AMI with the specified processor- x86_64 and storage gp2
  #This will help narrow down the search for the required AMI to use for our ec2 instance

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_ec2_instance_type" "t2_micro" {
  instance_type = "t2.micro"
}

resource "aws_launch_template" "fsb_launch_template" {
  name_prefix            = "fsbLT"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = data.aws_ec2_instance_type.t2_micro.id
  vpc_security_group_ids = [aws_security_group.My_sg.id]

  # Other launch template configurations...

  iam_instance_profile {
    name = aws_iam_instance_profile.fsb_instance_profile.name
  }

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
  name             = "fsb-asg"
  max_size         = 3
  min_size         = 1
  desired_capacity = 1
  launch_template {
    id      = aws_launch_template.fsb_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.private_subnet_id
  # Attach IAM role to ASG instances
  target_group_arns = [var.target_group_arn]
  tag {
    key                 = "Name"
    value               = "${var.env_code}-fsb_asg"
    propagate_at_launch = true
  }
}
