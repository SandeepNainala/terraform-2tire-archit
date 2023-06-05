# creating ec2 instance
resource "aws_instance" "my-web-instance1" {
  ami                         = "ami-0b5a2b5b8f2be4ec2"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.custom-public-SG-DB.id]
  tags                        = {
    Name = "web-instance1"
  }
  user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install httpd -y
      systemctl start httpd
      systemctl enable httpd
      echo "<html><body><h1> This is my Custom Project Tire 1 </h1></body></html> " > /var/www/html/index.html
      EOF
}

# creating ec2 instance
resource "aws_instance" "my-web-instance2" {
  ami                         = "ami-0b5a2b5b8f2be4ec2"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet2.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.custom-public-SG-DB.id]
  tags                        = {
    Name = "web-instance2"
  }
  user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install httpd -y
      systemctl start httpd
      systemctl enable httpd
      echo "<html><body><h1> This is my Custom Project Tire 2 </h1></body></html> " > /var/www/html/index.html
      EOF
}