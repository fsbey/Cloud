terraform {
  backend "s3" {
    bucket         = "tfremotestatefsb"
    key            = "fsb.tfstate"
    region         = "us-east-1"
    dynamodb_table = "fsb_dynamo_db"
  }
}
