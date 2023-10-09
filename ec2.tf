provider "aws" {
  region = "us-east-1" # Change to your desired AWS region
}

resource "aws_vpc" "VLAN" {
  cidr_block           = "192.166.0.0/16" # Change to your desired CIDR block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.VLAN.id
  cidr_block              = "192.166.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name        = "public_subnet_1"
    Environment = var.ENV
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.VLAN.id
  cidr_block              = "192.166.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name        = "public_subnet_2"
    Environment = var.ENV
  }
}


resource "aws_security_group" "public" {
  name_prefix = "allow-all"
  vpc_id      = aws_vpc.VLAN.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with this, it allows SSH access from anywhere
  }
  tags = {
    Name = "Security"
  }
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.VLAN.id
  tags = {
    Name = "internet_gateway_phuongnv63"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.VLAN.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name        = "route_table_phuongnv63"
    Environment = var.ENV
  }
}
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table.id

}
resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_instance" "my_instance_1" {
  ami             = "ami-067d1e60475437da2" # Specify your desired AMI ID
  instance_type   = "t2.micro"              # Specify your desired instance type
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.public.id]

  associate_public_ip_address = true # Assign a public IP

  key_name = "phuongnv63" # Specify the desired key pair name

  tags = {
    Name = "MyEC2Instance_1"
  }
}
resource "aws_instance" "my_instance_2" {
  ami             = "ami-067d1e60475437da2" # Specify your desired AMI ID
  instance_type   = "t2.micro"              # Specify your desired instance type
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.public.id]

  associate_public_ip_address = true # Assign a public IP

  key_name = "phuongnv63" # Specify the desired key pair name

  tags = {
    Name = "MyEC2Instance_2"
  }
}
resource "aws_instance" "my_instance_3" {
  ami             = "ami-067d1e60475437da2" # Specify your desired AMI ID
  instance_type   = "t2.micro"              # Specify your desired instance type
  subnet_id       = aws_subnet.public_subnet_2.id
  security_groups = [aws_security_group.public.id]

  associate_public_ip_address = true # Assign a public IP

  key_name = "phuongnv63" # Specify the desired key pair name

  tags = {
    Name = "MyEC2Instance_3"
  }
}
resource "aws_instance" "my_instance_4" {
  ami             = "ami-067d1e60475437da2" # Specify your desired AMI ID
  instance_type   = "t2.micro"              # Specify your desired instance type
  subnet_id       = aws_subnet.public_subnet_2.id
  security_groups = [aws_security_group.public.id]

  associate_public_ip_address = true # Assign a public IP

  key_name = "phuongnv63" # Specify the desired key pair name

  tags = {
    Name = "MyEC2Instance_4"
  }
}

variable "ENV" {
  default = "test"
}
