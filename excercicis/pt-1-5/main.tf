### HECHO POR SERGIO RAÚL MORALES SOLÍS ###
#Aqui creo el VPC con las variables del otro fichero
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cdir
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Aqui creo la/s subred/es publica usando las variables y el count
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    count = var.subnet_count
    cidr_block = cidrsubnet(var.vpc_cdir, 8, count.index)
    map_public_ip_on_launch = true
    tags = {
      Name = "${var.project_name}-public-${count.index}"
    }
}

# Aqui creo la/s subred/es privadas usando las variables y el count
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    count = var.subnet_count
    cidr_block = cidrsubnet(var.vpc_cdir, 8, count.index + var.subnet_count)
    tags = {
      Name = "${var.project_name}-private-${count.index}"
    }
}

# Aqui creo el Internet gateway **(En la practica pone que lo asociemos a la subred publica pero en la web de aws provider solo pone como asociarlo al vpc )**
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Aqui creo el grupo de seguridad con  los ingress y esgress
resource "aws_security_group" "sg" {
vpc_id = aws_vpc.main.id


ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.my_ip]
}


ingress {
from_port = -1
to_port = -1
protocol = "icmp"
cidr_blocks = [var.vpc_cdir]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}


  tags = {
    Name = "${var.project_name}-sg"
}
}

# Aqui creo las instancias publicas 
resource "aws_instance" "instance_public" {
  count = var.instance_count
  ami = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public[count.index].id
  key_name = "vockey"
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "${var.project_name}-instance-pub-${count.index}"
  }
}

# Aqui creo las instancias privadas
resource "aws_instance" "instance_private" {
  count = var.instance_count
  ami = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.private[count.index].id
  key_name = "vockey"
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "${var.project_name}-instance-priv-${count.index}"
  }
}

resource "aws_s3_bucket" "bucket" {
  count = var.create_s3_bucket ? 1 : 0
  bucket = "${var.project_name}-bucket"
  tags = {
    Name = "${var.project_name}-bucket"
  }
}