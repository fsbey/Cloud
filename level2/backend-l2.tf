terraform {
  backend "s3" {
    bucket         = "tfremotestatefsb"
    key            = "fsbL2.tfstate"
    region         = "us-east-1"
    dynamodb_table = data.aws_dynamodb_table.example_table.name
}
}
