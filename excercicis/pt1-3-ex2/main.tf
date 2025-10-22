provider "aws" {
  region = "us-east-1"
}

# AQUI CREO EL VPC
resource "aws_vpc" "vpc_network_main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-Network-Main"
  }
}

# AQUI CREO LAS SUBREDES
resource "aws_subnet" "subnet_network_a" {
  vpc_id            = aws_vpc.vpc_network_main.id
  cidr_block        = "10.0.32.0/25"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet-Network-A"
  }
}

resource "aws_subnet" "subnet_network_b" {
  vpc_id            = aws_vpc.vpc_network_main.id
  cidr_block        = "10.0.30.0/23"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet-Network-B"
  }
}

resource "aws_subnet" "subnet_network_c" {
  vpc_id            = aws_vpc.vpc_network_main.id
  cidr_block        = "10.0.33.0/28"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet-Network-C"
  }
}


# Y AQUI CREO LAS MAQUINAS EC2 
resource "aws_instance" "ec2_network_a_1" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_network_a.id
  vpc_security_group_ids = [aws_security_group.sg_network_access.id]

  tags = {
    Name = "EC2-Network-A-1"
  }
}

resource "aws_instance" "ec2_network_a_2" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_network_a.id
  vpc_security_group_ids = [aws_security_group.sg_network_access.id]

  tags = {
    Name = "EC2-Network-A-2"
  }
}

resource "aws_instance" "ec2_network_b_1" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_network_b.id
  vpc_security_group_ids = [aws_security_group.sg_network_access.id]

  tags = {
    Name = "EC2-Network-B-1"
  }
}

resource "aws_instance" "ec2_network_b_2" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_network_b.id
  vpc_security_group_ids = [aws_security_group.sg_network_access.id]

  tags = {
    Name = "EC2-Network-B-2"
  }
}

resource "aws_instance" "ec2_network_c_1" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_network_c.id
  vpc_security_group_ids = [aws_security_group.sg_network_access.id]

  tags = {
    Name = "EC2-Network-C-1"
  }
}

resource "aws_instance" "ec2_network_c_2" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet_network_c.id
  vpc_security_group_ids = [aws_security_group.sg_network_access.id]

  tags = {
    Name = "EC2-Network-C-2"
  }

}
