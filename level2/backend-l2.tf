terraform {
  backend "s3" {
    bucket         = data.aws_s3_bucket.example_bucket.id 
    key            = "fsb.tfstate"
    region         = "us-east-1"
    dynamodb_table = data.aws_dynamodb_table.example_table.name
}
}
