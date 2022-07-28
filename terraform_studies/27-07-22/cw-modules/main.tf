provider "aws" {
  region = "us-east-1"
}

module "docker_instance" {
    source = "avcimehmet/docker-instance/aws"
    key_name = "mykey"
}