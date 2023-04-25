locals {
  public_cidr = ["173.152.1.0/24", "173.152.2.0/24"]
  private_cidr = ["173.152.3.0/24", "173.152.4.0/24"]
  A_Z = ["us-east-1a", "us-east-1b"]
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "fsb_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
  Name = var.env_code
  }
}

resource "aws_internet_gateway" "fsb_igw" {
  vpc_id = aws_vpc.fsb_vpc.id

  tags = {
  Name = var.env_code
  }
}

resource "aws_subnet" "public" {
    count = length(local.public_cidr)
  vpc_id                  = aws_vpc.fsb_vpc.id
  cidr_block              = local.public_cidr[count.index]
  availability_zone       = local.A_Z[count.index]
  map_public_ip_on_launch = true

  tags = {
  Name = "$(var.env_code)-public${count.index}"
  }
}

resource "aws_subnet" "private" {
    count = length(local.private_cidr)
  vpc_id                  = aws_vpc.fsb_vpc.id
  cidr_block              = local.private_cidr[count.index]
  availability_zone       = local.A_Z[count.index]
  map_public_ip_on_launch = true

  tags = {
  Name = "$(var.env_code)-private${count.index}"
  }
}

# Create a public route table
resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.fsb_vpc.id

  # Route to the Internet Gateway
  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.fsb_igw.id
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "my_public_route_table_association1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.my_public_route_table.id
}

resource "aws_route_table_association" "my_public_route_table_association2" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.my_public_route_table.id
}

# Create a private route table 1
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.fsb_vpc.id

#ROUTE
  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
}

# Create a private route table 2
resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.fsb_vpc.id

  #ROUTE
  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }
}

# Associate private subnets with the private rt's
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table2.id
}

# Create 2 NAT Gateways & Associate with public subnets 1&2
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.public.id
}

# EIPs for the NAT Gateways
resource "aws_eip" "nat_gateway_1" {
  vpc = true
}

resource "aws_eip" "nat_gateway_2" {
  vpc = true
}
