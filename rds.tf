# creating db instance
resource "aws_db_instance" "my_database" {
  allocated_storage      = 10
  db_name                = "mybd"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.custom-subgroup.id
  vpc_security_group_ids = [aws_security_group.custom-public-SG-DB.id]
  username               = "username"
  password               = "password"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
}
# creating private security group for Database tire
resource "aws_security_group_instance" "my_database_tier-lu" {
  name        = "my_database_tier_lu"
  description = "allow traffic from SSH & HTTP"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port       = 8279
    to_port         = 8279
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
    security_groups = [aws_security_group.SG.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
