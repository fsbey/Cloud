locals {
  public_cidr         = ["168.150.1.0/24", "168.150.2.0/24"]
  private_cidr        = ["168.150.3.0/24", "168.150.4.0/24"]
  A_Z                 = ["us-east-1a", "us-east-1b"]
  private_route_table = ["168.150.3.0/24", "168.150.4.0/24"]
}

resource "aws_vpc" "fsb_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env_code}-fsb_vpc"
  }
}

resource "aws_internet_gateway" "fsb_igw" {
  vpc_id = aws_vpc.fsb_vpc.id

  tags = {
    Name = "${var.env_code}-fsb_igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.public_cidr)
  vpc_id                  = aws_vpc.fsb_vpc.id
  cidr_block              = local.public_cidr[count.index]
  availability_zone       = local.A_Z[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_code}-public_subnet${count.index}"
  }
}


#Public route table associated with the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.fsb_vpc.id

  #ROUTE 
  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.fsb_igw.id
  }
  tags = {
    Name = "${var.env_code}-publicRT"
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(local.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}



resource "aws_subnet" "private" {
  count                   = length(local.private_cidr)
  vpc_id                  = aws_vpc.fsb_vpc.id
  cidr_block              = local.private_cidr[count.index]
  availability_zone       = local.A_Z[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_code}-private_subnet${count.index}"
  }
}

#Private route tables 
resource "aws_route_table" "private" {
  count  = length(local.private_cidr)
  vpc_id = aws_vpc.fsb_vpc.id

  #ROUTE 
  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }
  tags = {
    Name = "${var.env_code}-privateRT${count.index}"
  }
}

# Associate the private subnets with the private route tables
resource "aws_route_table_association" "private" {
  count          = length(local.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


# Create 2 NAT Gateways & Associate with public subnets 1&2
resource "aws_nat_gateway" "nat_gateways" {
  count         = length(local.public_cidr)
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.env_code}-Nat_GW${count.index}"
  }
}

# EIPs for the NAT Gateways
resource "aws_eip" "nat_gateway" {
  count = length(local.public_cidr)
  vpc   = true

  tags = {
    Name = "${var.env_code}-NatGW_EIP${count.index}"
  }
}
