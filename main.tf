resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
}
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "subnet1"
  }
}
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-gw"
  }
}
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags = {
    Name = "main-rt"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      =aws_subnet.subnet1.id
  route_table_id = aws_route_table.main-rt.id
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }

}
resource "aws_instance" "windown" {
    instance_type = "t2.micro"
    ami = "ami-0b09627181c8d5778"
    availability_zone = "ap-south-1"
    key_name = "mumbai123"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = aws_security_group. allow_tls.id
    tags = {
        Name=windown
    }
  
}