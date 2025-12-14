### HECHO POR SERGIO RAÚL MORALES SOLÍS ###
#Aqui creo el VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-main"
  }
}

# Aqui creo el internet gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw"
  }
}

# Aqui creo las Redes publicas y privadas
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-public"
  }
}

resource "aws_subnet" "private_sub" {
  count      = var.private_instance_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet("10.0.0.0/16", 8, count.index + 2)
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-private"
  }
}

# Aqui creo una IP elastica y la asocio al nat gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "EIP_NAT_GW"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public.id
}

# Aqui creo las tablas de enrutamiento para que el trafico que no vaya a ninguna parte de la red salga a internet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "Private_RT"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.private_instance_count
  subnet_id      = aws_subnet.private_sub[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Aqui creo los grupos de seguridad 
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH desde la IP definida en el fichero variables (en mi caso he vuelto a poner 0.0.0.0/0 para no complicarme)"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "Public-SG"
  }
}

resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH solo desde el Bastion"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "Comunicacion interna entre las subredes privadas"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    self = true
  }

  egress {
    description = "Permitimos todo el trafico saliente"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Private_SG"
  }
}

# Aqui creo las calves del bastion
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "bastion_kp" {
  key_name = "bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

# Aqui creo las claves de las instancias privadas
resource "tls_private_key" "private_keys" {
  count = var.private_instance_count
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "private_kp" {
  count = var.private_instance_count
  key_name = "private-key-${count.index}"
  public_key = tls_private_key.private_keys[count.index].public_key_openssh
}

# Aqui creo los ficheros .pem
resource "local_file" "bastion-pem" {
  filename = "${path.module}/bastion.pem"
  content = tls_private_key.bastion_key.private_key_pem
  file_permission = "0400"
}

resource "local_file" "private-pem" {
  count = var.private_instance_count
  filename = "${path.module}/private-${count.index + 1}.pem"
  content = tls_private_key.private_keys[count.index].private_key_pem
  file_permission = "0400"
}

# Aqui creo las instancias
# Pero primero creo la IP elastica para el bastion
resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  instance = aws_instance.bastion.id
  tags = {
    Name = "Bastion_EIP"
  }
}

resource "aws_instance" "bastion" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.bastion_sg.id] 
  key_name = aws_key_pair.bastion_kp.key_name
  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "private" {
  count = var.private_instance_count
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_sub[count.index].id
  security_groups = [aws_security_group.private_sg.id]
  key_name = aws_key_pair.private_kp[count.index].key_name
  tags = {
    Name = "Private${count.index}"
  }
}

# Aqui empiezo la configuracionn del backet
resource "aws_s3_bucket" "keys" {
  bucket = "bucket-srms-pt-1-6"
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.keys.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "bastion_pub" {
  bucket = aws_s3_bucket.keys.id
  key = "bastion.pub"
  content = tls_private_key.bastion_key.public_key_openssh
}

resource "aws_s3_object" "private_pub" {
  count = var.private_instance_count
  bucket = aws_s3_bucket.keys.id
  key = "private-${count.index + 1}.pub"
  content = tls_private_key.private_keys[count.index].public_key_openssh
}

# Configuracion del SSHCONFIG
resource "local_file" "ssh_config" {
  content = templatefile("${path.module}/ssh_config.tpl", {
    bastion_ip   = aws_eip.bastion_eip.public_ip
    bastion_user = "ec2-user"
    bastion_key  = "bastion.pem"
    private_ips  = aws_instance.private[*].private_ip
    private_keys = [for i in range(var.private_instance_count) : "private-${i + 1}.pem"]
  })
  filename = "${path.module}/ssh_config_per_connect.txt"
}