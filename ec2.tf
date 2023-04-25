# Launch an EC2 instance in the first private subnet
resource "aws_instance" "my_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.CloudSG.id]
  
  tags = {
  Name = var.env_code
  }  
}

