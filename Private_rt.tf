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
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table2.id
}
