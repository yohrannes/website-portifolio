terraform {
  backend "s3" {
    bucket = "port-bucket-tfstate"
    key    = "port.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
