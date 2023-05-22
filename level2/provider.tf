provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "tfremotestatefsb"
    key            = "level2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "fsb_dynamo_db"
  }
}
