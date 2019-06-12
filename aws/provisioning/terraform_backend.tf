terraform {
  backend "s3" {
    bucket         = "wordpress-basic.tfstate.d"
    dynamodb_table = "wordpress-basic.tfstate.d"
    key            = "state/key"
    region         = "eu-west-1"
  }
}
