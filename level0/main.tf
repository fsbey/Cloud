resource "aws_dynamodb_table" "lock_table" {
  name         = "fsb_dynamo_db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "fsb_bucket" {
  bucket = "tfremotestatefsb"
  tags = {
    Name = "tfremotestatefsb"
  }
}
