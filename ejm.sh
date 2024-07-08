#!/bin/bash

# Actualizar lista de paquetes
echo "Actualizando la lista de paquetes..."
sudo apt-get update

# Instalar Python 3 si no está instalado
echo "Instalando Python 3..."
sudo apt-get install -y python3

# Instalar pip para Python 3 si no está instalado
echo "Instalando pip para Python 3..."
sudo apt-get install -y python3-pip

# Instalar pandas y matplotlib usando pip
echo "Instalando pandas y matplotlib..."
pip3 install pandas matplotlib

# Instalar stress
echo "Instalando stress..."
sudo apt-get install -y stress

echo "Instalación completada."
