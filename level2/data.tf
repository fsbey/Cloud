#Remote state datasource as the vpc details are in level1
data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "tfremotestatefsb"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}
