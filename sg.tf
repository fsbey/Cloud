# Create a security group
resource "aws_security_group" "CloudSG" {
  name_prefix = var.SGname
  vpc_id      = aws_vpc.fsb_vpc.id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks]
  }
}

