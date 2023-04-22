provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2tf" {
  ami           = "ami-0fc61db8544a617ed"
  instance_type = "t2.micro"

  iam_instance_profile = "ec2_role_ssm"

  tags = {
    Name = "ec2tf"
  }
}
