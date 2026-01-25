resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.first_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web-sg.id]
    user_data = <<-EOF
  #!/bin/bash
  set -e

  dnf -y update
  dnf -y install httpd

  systemctl enable httpd
  systemctl start httpd

  echo "<html><h1>Hello DevOps Cloud Gurus Welcome To My Webpage</h1></html>" > /var/www/html/index.html
  EOF




  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_default_vpc" "default" {
  enable_dns_hostnames = true

}

data "aws_vpc" "default" {
  id = aws_default_vpc.default.id
}

resource "aws_subnet" "first_subnet" {
  vpc_id            = aws_default_vpc.default.id
  availability_zone = var.availability_zone



  cidr_block = cidrsubnet(data.aws_vpc.default.cidr_block, 4, 1)

}



