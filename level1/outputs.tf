output "vpc_id" {
  value = aws_vpc.fsb_vpc.id  
}

output "public_subnet_id" {
  value = aws_subnet.public[*].id    
}

output "private_subnet_id" {
  value = aws_subnet.private[*].id    
}

output "cidr_block" {
  value = var.cidr_block   
}
