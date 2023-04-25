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
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.my_public_route_table.id
}

resource "aws_route_table_association" "my_public_route_table_association2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.my_public_route_table.id
}