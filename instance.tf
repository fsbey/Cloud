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
    name   = "kernel-id"
    values = ["*5.10*"]
  }

  owners = ["amazon"]
}

# Launch an EC2 instance with a sec group and key_name parameter
resource "aws_instance" "fsb_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = "MyKeyPair"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.FSB_SG.id]


  tags = {
    Name = "${var.env_code}-instance"
  }
}

#CREATE SG
resource "aws_security_group" "FSB_SG" {
  name_prefix = var.SGname2
  vpc_id      = aws_vpc.fsb_vpc.id

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

  tags = {
    Name = "${var.env_code}-fsb-security-group"
  }
}
