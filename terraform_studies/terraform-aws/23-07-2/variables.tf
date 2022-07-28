variable "ec2_name" {
  default = "oliver-ec2"
}

variable "ec2_type" {
  default = "t2.micro"
}

#variable "ec2_ami" {
#  default = "ami-0cff7528ff583bf9a"
#}

variable "num_of_buckets" {
  default = 2
}

#variable "s3_bucket_name" {
#   default = "oliver-s3-bucket-variable-newewew"
#}

variable "users" {
  default = ["santino", "michael", "fredo"]
}