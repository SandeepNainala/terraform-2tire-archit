# creating a VPC
  resource "aws_vpc" "custom_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "custom vpc"
  }
}

#creating a internet gate way

  resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "igw"
  }
}

# Creating an elastic ip
  resource "aws_eip" "custom_eip" {
  domain   = "vpc"
  }

# creating NAT gateway association with an Elastic ip
  resource "aws_nat_gateway" "custom-nat-gw" {
    allocation_id = aws_eip.custom_eip.id
    subnet_id     = aws_subnet.example.id

    tags = {
      Name = "custom NAT"
    }
  }
    # creating a NAT route
    resource "aws_route_table" "private_route_table" {
      vpc_id = aws_vpc.custom_vpc.id

      route {
        cidr_block     = "10.0.1.0/24"
        nat_gateway_id = aws_nat_gateway.custom-nat-gw.id
      }
      tags = {
        Name = "custom-Network-Address-route"
      }
    }
      # creating public subnet

      resource "aws_subnet" "public-subnet1" {
        vpc_id                          = aws_vpc.custom_vpc.id
        cidr_block                      = "10.0.1.0/24"
        availability_zone_id            = "us-east-1"
        map_customer_owned_ip_on_launch = true

        tags = {
          Name = "public-subnet1"
        }
      }
      # creating public subnet

      resource "aws_subnet" "public-subnet2" {
        vpc_id                          = aws_vpc.custom_vpc.id
        cidr_block                      = "10.0.1.0/24"
        availability_zone_id            = "us-east-1"
        map_customer_owned_ip_on_launch = true

        tags = {
          Name = "public-subnet2"
        }
      }
      # creating private subnet

      resource "aws_subnet" "private-subnet1" {
        vpc_id                          = aws_vpc.custom_vpc.id
        cidr_block                      = "10.0.3.0/24"
        availability_zone_id            = "us-east-1"
        map_customer_owned_ip_on_launch = false

        tags = {
          Name = "private-subnet1"
        }
      }
      # creating public subnet

      resource "aws_subnet" "private-subnet2" {
        vpc_id                          = aws_vpc.custom_vpc.id
        cidr_block                      = "10.0.4.0/24"
        availability_zone_id            = "us-east-1"
        map_customer_owned_ip_on_launch = false

        tags = {
          Name = "private-subnet2"
        }
      }

      # creating subnet groups
      resource "aws_db_subnet_group" "custom-subgroup" {
        name       = "custom-subgroup"
        subnet_ids = [aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id]

        tags = {
          Name = "My Data base subnet group"
        }
      }
      # creating route table association

      resource "aws_route_table_association" "private_route_table_ass_1" {
        subnet_id      = aws_subnet.private-subnet1.id
        route_table_id = aws_route_table.private_route_table.id
      }
      resource "aws_route_table_association" "private_route_table_ass_2" {
        subnet_id      = aws_subnet.private-subnet2.id
        route_table_id = aws_route_table.private_route_table.id
      }
# creating a security group
      resource "aws_security_group" "SG" {
      name        = "SG"
      description = "Security group for Load balancer"
      vpc_id      = aws_vpc.custom_vpc.id

     ingress {
     from_port        = "0"
     to_port          = "0"
     protocol         = "-1"
     cidr_blocks      = ["0.0.0.0/0"]
    }

     egress {
     from_port        = 0
     to_port          = 0
     protocol         = "-1"
     cidr_blocks      = ["0.0.0.0/0"]
     }

    tags = {
    Name = "SG"
    }
  }

# creating a load balancer
   resource "aws_lb" "LB" {
     name               = "LB"
     internal           = false
     load_balancer_type = "application"
     security_groups    = [aws_security_group.SG.id]
     subnets            = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
   }

# creating load balancer target group
   resource "aws_lb_target_group" "lb-tg" {
   name     = "customtargetgroup"
   port     = 80
   protocol = "HTTP"
   vpc_id   = aws_vpc.custom_vpc.id

   depends_on = [aws_vpc.custom_vpc.id]
   }

# creating load balancer target group
   resource "aws_lb_target_group_attachment" "target-group1" {
     target_group_arn   = aws_lb_target_group.lb-tg.arn
     target_id          = aws_instance.my-web-instance1.id
     port               = 80

     depends_on = [aws_instance.my-web-instance1]
   }
# creating load balancer target group
   resource "aws_lb_target_group_attachment" "target-group2" {
   target_group_arn    = aws_lb_target_group.lb-tg.arn
   target_id           = aws_instance.my-web-instance2.id
   port                = 80

   depends_on = [aws_instance.my-web-instance2]
   }

