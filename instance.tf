provider "aws" {
  region = var.region
}

# Launch an EC2 instance with a sec group and key_name parameter
resource "aws_instance" "fsb_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "MyKeyPair"

  tags = {
    Name = "${var.env_code}-instance"
  }
}


resource "aws_security_group" "SG" {
  name_prefix = "example"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fsb-security-group"
  }
}