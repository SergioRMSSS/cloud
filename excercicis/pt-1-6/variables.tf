### HECHO POR SERGIO RAÚL MORALES SOLÍS ###
variable "region" {
  description = "Regió AWS"
  type = string
  default = "us-east-1"
}

variable "private_instance_count" {
    description = "esta variable nos dice el numero de redes privadas"
    type = number
    default = 2
}

variable "allowed_ip" {
  description = "nos dira que IP se puede conectar desde fuera por el puerto 22"
  type = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
  description = "La instancia que usaremos ya que asi es mas simple de cambiar y de pones despues en el main"
  type = string
  default = "t3.micro"
}

variable "ami" {
  description = "Usamos una variable para la AMI porque es mas sencillo"
  type = string
  default = "ami-068c0051b15cdb816"
}

