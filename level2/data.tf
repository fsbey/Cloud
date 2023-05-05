data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

}

data "aws_s3_bucket" "example_bucket" {
  bucket = "tfremotestatefsb"
}

output "bucket_name" {
  value = data.aws_s3_bucket.example_bucket.id
}

data "aws_dynamodb_table" "example_table" {
  name = "fsb_dynamo_dbtable"
}

output "table_name" {
  value = data.aws_dynamodb_table.example_table.name
}
