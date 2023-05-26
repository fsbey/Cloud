locals {
  private_cidr = ["168.150.3.0/24", "168.150.4.0/24"]
  A_Z          = ["us-east-1a", "us-east-1b"]
}

# resource "aws_instance" "fsb_server" {
#   count                  = length(local.private_cidr)
#   ami                    = data.aws_ami.amazon_linux_2.id
#   instance_type          = data.aws_ec2_instance_type.t2_micro.id
#   key_name               = "OG"
#   subnet_id              = var.private_subnet_id[count.index]
#   iam_instance_profile   = "ec2_role_ssm"
#   vpc_security_group_ids = [aws_security_group.My_sg.id]

#   user_data = <<-EOF
#     #!/bin/bash
#     yum update -y
#     yum install -y amazon-ssm-agent
#     yum install -y httpd
#     systemctl start httpd
#     systemctl enable httpd
#     yum install -y git
#     cd /var/www/html
#     git clone https://github.com/gabrielecirulli/2048.git
#     cd 2048
#     mv * ../
#     cd ..
#     rm -rf 2048
#     systemctl restart httpd
#     EOF

#   tags = {
#     Name = "${var.env_code}-instance${count.index}"
#   }
# }

#CREATE SG
resource "aws_security_group" "My_sg" {
  name_prefix = "${var.env_code}-SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.load_balancer_sg]
  }



  # This means that outbound traffic on port 80 & 443 
  # using the protocol specified in the var.protocol variable is allowed to the IP address range 0.0.0.0/0
  # specified in the cidr_block variable. This rule allows traffic to flow from the 
  # resource associated with the security group 
  # to the specified IP address range on port 80 and 443.

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-private"
  }
}
