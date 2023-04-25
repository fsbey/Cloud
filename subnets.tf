resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.fsb_vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.AZ-1a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.fsb_vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = var.AZ-1b
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.fsb_vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.AZ-1a
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.fsb_vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.AZ-1b
}