provider "aws" {
    region = "us-east-1"
}

#Aqui creamos el VPC
resource "aws_vpc" "VPC-03" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "VPC-03"
    }
}

# Subred publica 1 us-east-1a
resource "aws_subnet" "subred-1a" {
  vpc_id                  = aws_vpc.VPC-03.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subred-1a"
  }
}

# Subred publica 2 us-east-1b
resource "aws_subnet" "subred-1b" {
  vpc_id                  = aws_vpc.VPC-03.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subred-1b"
  }
}

# Internet Gateway asociado VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC-03.id

  tags = {
    Name = "VPC-03-IGW"
  }
}

# Tabla de rutas pública 
resource "aws_route_table" "tabla_rutas" {
  vpc_id = aws_vpc.VPC-03.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "VPC-03-Public-RT"
  }
}

# Asociacion de tabla de rutas a las subredes
resource "aws_route_table_association" "tabla_rutas_1" {
  subnet_id      = aws_subnet.subred_1a.id
  route_table_id = aws_route_table.tabla_rutas.id
}
resource "aws_route_table_association" "tabla_rutas_2" {
  subnet_id      = aws_subnet.subred_1b.id
  route_table_id = aws_route_table.tabla_rutas.id
}

# Security Group para las instancias públicas
resource "aws_security_group" "public_sg" {
  name        = "VPC-03-Public-SG"
  description = "Permite SSH desde cualquier lugar, ICMP dentro del VPC, y todo el tráfico saliente"
  vpc_id      = aws_vpc.VPC-03.id

  # Permite SSH desde cualquier lugar
  ingress {
    description      = "SSH desde cualquier lugar"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Permite ICMP solo dentro de la VPC
  ingress {
    description      = "ICMP dentro de la VPC"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [aws_vpc.VPC-03.cidr_block]
  }

  # Todo el tráfico saliente
  egress {
    description      = "Todo el tráfico saliente"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Grupo_Seguridad_VPC-03"
  }
}

# Instancia subred-1a
resource "aws_instance" "ec2_a" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subred-1a.id
  key_name      = "vockey"
  security_groups = [aws_security_group.public_sg.name]
  tags = {
    Name = "ec2-a"
  }
}

# Instancia subred-1b
resource "aws_instance" "ec2_b" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subred-1b.id
  key_name      = "vockey"
  security_groups = [aws_security_group.public_sg.name]
  tags = {
    Name = "ec2-b"
  }
}