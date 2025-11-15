resource "aws_s3_bucket" "bucket" {
  bucket = "port-bucket-tfstate"
}

provider "aws" {
  region = "us-east-1"
}