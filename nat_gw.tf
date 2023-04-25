# Create 2 NAT Gateways & Associate with public subnets 1&2
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
}

# EIPs for the NAT Gateways
resource "aws_eip" "nat_gateway_1" {
  vpc = true
}

resource "aws_eip" "nat_gateway_2" {
  vpc = true
}
