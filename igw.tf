resource "aws_internet_gateway" "fsb_igw" {
  vpc_id = aws_vpc.fsb_vpc.id
}