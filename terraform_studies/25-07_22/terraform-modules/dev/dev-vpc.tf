module "tf-vpc" {
  source = "../modules"
  environment = "DEV"
  public_subnet_cidr = "10.0.7.0/24"
}

#output "vpc-cidr-block" {
#  value = module.tf-vpc.vpc_cidr
#}

#output "vpc-subnet-cidr" {
#  value = module.tf-vpc.public_subnet_cidr
#}


resource "aws_s3_bucket" "tf-s3" {
  bucket = "mavci-tf-s3-bucket"
}