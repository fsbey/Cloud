#variable 
variable "region" {
}

variable "vpc_cidr" {
}

#SUBNETS
variable "public_subnet_cidr" {
}
variable "private_subnet1_cidr" {
}
variable "private_subnet2_cidr" {
}
variable "AZ-1a" {
}
variable "AZ-1b" {
}

variable "cidr_block" {
}

#SEC-GROUP-DETAILS
variable "cidr_blocks" {
}
variable "protocol" {
}
variable "port" {
}
variable "SGname" {
}
variable "port2" {
}
variable "SGname2" {
}

#INSTANCE DETAILS
variable "ami" {
}
variable "instance_type" {
}

variable "env_code" {
  type = string
}
