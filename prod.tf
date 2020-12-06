provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
  shared_credentials_file = "./credentials"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-theara"
  acl    = "private"
}
