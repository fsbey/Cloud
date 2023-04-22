resource "aws_vpc" "fsb_vpc" {
  cidr_block = "173.152.0.0/16"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.fsb_vpc.id
  cidr_block = "173.152.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.fsb_vpc.id
  cidr_block = "173.152.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.fsb_vpc.id
  cidr_block = "173.152.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.fsb_vpc.id
  cidr_block = "173.152.4.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "fsb_igw" {
  vpc_id = aws_vpc.fsb_vpc.id
}

# Create a public route table
resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.fsb_vpc.id

  # Route to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fsb_igw.id
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "my_public_route_table_association1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.my_public_route_table.id
}

resource "aws_route_table_association" "my_public_route_table_association2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.my_public_route_table.id
}

# Create 2 NAT Gateways
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.private_subnet_1.id
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.private_subnet_2.id
}

# EIPs for the NAT Gateways
resource "aws_eip" "nat_gateway_1" {
  vpc = true
}

resource "aws_eip" "nat_gateway_2" {
  vpc = true
}


# Create a private route table 1
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.fsb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.fsb_vpc.id

# Add a route to the NAT gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }
}


# Associate private subnets with the NAT Gateways
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table2.id
}


# Create a security group
resource "aws_security_group" "my_security_group" {
  name_prefix = "my_security_group"
  vpc_id      = aws_vpc.fsb_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance in the first private subnet
resource "aws_instance" "my_instance" {
  ami           = "ami-0a887e401f7654935"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}