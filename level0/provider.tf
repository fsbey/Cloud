provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tfremotestatefsb"
    key    = "level0.tfstate"
    region = "us-east-1"
  }
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

resource "aws_dynamodb_table" "lock_table" {
  name         = "fsb_dynamo_db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
