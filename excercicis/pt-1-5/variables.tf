### HECHO POR SERGIO RAÚL MORALES SOLÍS ###
variable "region" {
  description = "Regió AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del projecto"
  type = string
}

variable "instance_count" {
  description = "Con esta variable sabemos cuantas instancias vamos a crear"
  type = number
  default = 1
}

variable "subnet_count" {
  description = "Aqui se define cuantas subredes habra"
  type = number
  default = 2
}

variable "instance_type" {
    description = "Aqui elegimos que tipo de instancia se quiere"
    type = string
    default = "t3.micro"
}

variable "instance_ami" {
  description = "Aqui definimos la ami que se usara"
  type = string
  default = "ami-0cae6d6fe6048ca2c"
}

variable "create_s3_bucket" {
  description = "Crear bucket S3 condicionalment "
  type        = bool
  default     = false
}

variable "vpc_cdir" {
  description = "Aqui se define el cdir que en anteriores practicas haciamos en el main"
  type = string
  default = "10.0.0.0/16"
}

variable "my_ip" {
  description = "Aqui deberia ir mi IP publica con la que salgo a internet pero para no complicarme mucho he puesto esto"
  type = string
  default = "0.0.0.0/0"
}