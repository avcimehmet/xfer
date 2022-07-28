terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "tf-ami" {
  type = list(string)
  default = [ "ami-0cff7528ff583bf9a", "ami-052efd3df9dad4825","ami-06640050dc3f556bb" ]
}

variable "tags" {
  type = list(string)
  default = ["kamber linux", "kamber ubuntu", "kamber red-hat"]
}

resource "aws_instance" "tf-instance" {
  ami = element(var.tf-ami, count.index)
  instance_type = "t2.micro"
  key_name = "mykey"
  count = 3
  security_groups = [ "kamber-sg-import" ]
  tags = {
    Name = element(var.tags, count.index)
  }
}

resource "aws_security_group" "tf-sg" {
  name = "kamber-sg-import"
  description = "kambers connection allowed"
  tags = {
    Name = "kamber"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}