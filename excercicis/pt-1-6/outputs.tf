### HECHO POR SERGIO RAÚL MORALES SOLÍS ###
output "bastion_public_ip" {
  value = aws_eip.bastion_eip.public_ip
}

output "private_instances_ips" {
  value = aws_instance.private_servers[*].private_ip
}