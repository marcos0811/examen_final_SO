#!/bin/bash

# Actualizamos lista de paquetes
echo "Actualizando la lista de paquetes..."
sudo apt-get update

#Instalamos msmtp para el envio de correos
echo "Instalando msmtp..."
sudo apt-get install -y msmtp

# Instalamos Python 3 para la creacion de la grafica
echo "Instalando Python 3..."
sudo apt-get install -y python3

# Instalamos pip para Python 3
echo "Instalando pip para Python 3..."
sudo apt-get install -y python3-pip

# Instalamos pandas y matplotlib usando pip
echo "Instalando pandas y matplotlib..."
pip3 install pandas matplotlib

# Instalamos stress para generar una sobrecarga en els sistema con comandos especificos
echo "Instalando stress..."
sudo apt-get install -y stress

echo "Instalación completada."
