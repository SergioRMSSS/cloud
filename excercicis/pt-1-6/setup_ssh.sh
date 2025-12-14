#!/bin/bash

# Aqui movemos las .pem al directorio 
mv bastion.pem ~/.ssh/
mv private-*.pem

# Aqui se cambian los permisos de las claves aunque no es necesario ya que lo hago en main.tf pero bueno
chmod 400 ~/.ssh/bastion.pem
chmod 400 ~/.ssh/private-*.pem

# Aqui se crea el fichero c0onfig sin que se duplique en caso de que ya exista. Y tambien se mueve la informacion a este
touch ~/.ssh/config
cat ssh_config_per_connect.txt > ~/.ssh/config