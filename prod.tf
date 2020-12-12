provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
  shared_credentials_file = "./credentials"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-theara"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {

  availability_zone = "ap-southeast-1a"

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_default_subnet" "default_az2" {

  availability_zone = "ap-southeast-1b"

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_security_group" "prod_web" {

  name   = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_instance" "prod_web" {
  ami           = "ami-0132879a9184f4639"
  instance_type = "t2.nano"
  
  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prod_web" {
  name            = "prod-web"
  instances       = aws_instance.prod_web.*.id
  subnets         = [ aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id ]
  security_groups = [ aws_security_group.prod_web.id ]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  tags = {
    "Terraform" : "true"
  }

}

