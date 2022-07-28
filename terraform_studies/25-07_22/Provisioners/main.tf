terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name = "mykey"
  security_groups = [ "tf-provisioner-sg" ]
  tags = {
    Name = "terraform-instance-with-provisioner"
  }

  provisioner "local-exec" {
      command = "echo public dns: ${self.public_dns} >> public_dns.txt"
  }

  connection {
    host = self.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("/home/ec2-user/25-07_22/Provisioners/mykey.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "cd /var/www/html",
      "sudo wget https://raw.githubusercontent.com/avcimehmet/my-projects/master/AWS/projects/Project-101-kittens-carousel-static-website-ec2/static-web/index.html",
      "sudo wget https://raw.githubusercontent.com/avcimehmet/my-projects/master/AWS/projects/Project-101-kittens-carousel-static-website-ec2/static-web/cat0.jpg",
      "sudo wget https://raw.githubusercontent.com/avcimehmet/my-projects/master/AWS/projects/Project-101-kittens-carousel-static-website-ec2/static-web/cat1.jpg",
      "sudo wget https://raw.githubusercontent.com/avcimehmet/my-projects/master/AWS/projects/Project-101-kittens-carousel-static-website-ec2/static-web/cat2.jpg",
      "sudo wget https://raw.githubusercontent.com/avcimehmet/my-projects/master/AWS/projects/Project-101-kittens-carousel-static-website-ec2/static-web/cat3.png",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  provisioner "file" {
    source = "/home/ec2-user/25-07_22/Provisioners/README-4.md"
    destination = "/home/ec2-user/"
  }

}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-provisioner-sg"
  tags = {
    Name = "terraform-http-ssh"
  }
  
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      protocol = "tcp"
      to_port = 22
      cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
      from_port = 0
      protocol = -1
      to_port = 0
      cidr_blocks = [ "0.0.0.0/0" ]
  }
}