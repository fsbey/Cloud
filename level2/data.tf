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

#Remote state datasource as the vpc details are in level1
data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "tfremotestatefsb"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}
