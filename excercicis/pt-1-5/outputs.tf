### HECHO POR SERGIO RAÚL MORALES SOLÍS ###
#Aqui creo un output que me permite ver el ID de las maquinas publicas
###### Esto es para Sergio, en principio lo que he entendido es que el "intancias in aws_instance.instance_public" instancias referencias a aws_instance.instance_public , como en SQL 
output "ID_ins_pub" {
  value = [for instancias in aws_instance.instance_public : instancias.id]
  description = "Esto lo que hace es mostrar el ID de las maquinas publicas"
}

output "ID_ins_priv" {
  value = [for instancias in aws_instance.instance_private : instancias.id]
    description = "Esto lo que hace es mostrar el ID de las maquinas privadas"
}

output "IPs_ins_pub" {
  value = [for i in aws_instance.instance_public : i.public_ip]
  description = "ESto hace que nos muestre las IPs publicas"
}

output "IPs_ins_pub_priv" {
  value = [for i in aws_instance.instance_public : i.private_ip]
  description = "ESto hace que nos muestre las IPs publicas"
}

output "IPs_ins_priv" {
  value = [for i in aws_instance.instance_private : i.private_ip]
  description = "Con esto conseguimos que nos de las IPs de las maquinas que son privadas"
}

output "bucket_name" {
  value = var.create_s3_bucket ? aws_s3_bucket.optional[0].bucket : null
}
