# Comfigurar proveedor
provider "aws" {
    region = "us-east-1"
}

# Creamos la primera insancia de EC2
resource "aws_instance" "insancia1-ex1" {
    instance_type = "t3.micro"
    ami = "ami-052064a798f08f0d3"

    tags = {
      Name = "Instancia 1"
    }
}

# Creamos la segunda insancia de EC2
resource "aws_instance" "insancia2-ex1" {
    instance_type = "t3.micro"
    ami = "ami-052064a798f08f0d3"

    tags = {
      Name = "Instancia 2"
    }
}