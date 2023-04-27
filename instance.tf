provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

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

# Launch an EC2 instance with a sec group and key_name parameter
resource "aws_instance" "fsb_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = "OG"
  subnet_id              = "subnet-0332aa50e8a8681cb"
  vpc_security_group_ids = [aws_security_group.My_sg.id]
  iam_instance_profile   = "ec2_role_ssm"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    EOF


  tags = {
    Name = "${var.env_code}-instance"
  }
}

#CREATE SG
resource "aws_security_group" "My_sg" {
  name_prefix = var.SGname2
  vpc_id      = "vpc-0ca70b4fc5a1ecdca"

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = var.port2
    to_port     = var.port2
    protocol    = var.protocol
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "${var.env_code}-my_SG"
  }
}
