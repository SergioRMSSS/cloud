#!/bin/bash

# Aqui movemos las .pem al directorio 
mv bastion.pem /home/sergio/.ssh/
mv private-*.pem /home/sergio/.ssh/

# Aqui se cambian los permisos de las claves aunque no es necesario ya que lo hago en main.tf pero bueno
chmod 400 /home/sergio/.ssh/bastion.pem
chmod 400 /home/sergio/.ssh/private-*.pem

# Aqui se crea el fichero c0onfig sin que se duplique en caso de que ya exista. Y tambien se mueve la informacion a este
touch ~/.ssh/config
cat ssh_config_per_connect.txt > /home/sergio/.ssh/config