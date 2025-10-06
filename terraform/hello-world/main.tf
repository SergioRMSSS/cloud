# Comfigurar proveedor
provider "aws" {
    region = "us-east-1"
}

# Creamos una insancia de EC2
resource "aws_instance" "hello-world" {
    instance_type = "t2.micro"
    ami = "ami-052064a798f08f0d3"

    tags = {
      name = "terraform-primer-vistazo"
    }
}