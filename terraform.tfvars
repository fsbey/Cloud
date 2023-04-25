region               = "us-east-1"
vpc_cidr             = "173.152.0.0/16"
public_subnet_cidr   = "173.152.0.0/24"
private_subnet1_cidr = "173.152.3.0/24"
private_subnet2_cidr = "173.152.4.0/24"
AZ-1a                = "us-east-1a"
AZ-1b                = "us-east-1b"
cidr_block           = "0.0.0.0/0"
cidr_blocks          = "0.0.0.0/0"
protocol             = "tcp"
port                 = "22"
SGname               = "CloudSG"
ami                  = "ami-0a887e401f7654935"
instance_type        = "t2.micro"
env_code             = "mentorship"