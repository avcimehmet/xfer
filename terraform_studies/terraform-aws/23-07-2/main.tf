terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

}

locals {
  mytag = "mavci-local-name"
}

data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2_type
  key_name      = "mykey"
  tags = {
    Name = "${local.mytag}-this is from my-ami-mavci"
  }
}

resource "aws_s3_bucket" "tf-s30" {
  # bucket = "${var.s3_bucket_name}-${count.index}"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 3
  for_each = toset(var.users)
  bucket = "mavci-tf-s3-bucket-${each.value}"
}


output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

# output "tf_example_s3_meta" {
#   value = aws_s3_bucket.tf-s3[*]
# }

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}