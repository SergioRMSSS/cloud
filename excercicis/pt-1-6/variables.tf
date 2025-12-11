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