#!/bin/bash

# Actualizar lista de paquetes
echo "Actualizando la lista de paquetes..."
sudo apt-get update

# Instalar Python 3 si no está instalado
if ! command -v python3 &> /dev/null; then
    echo "Instalando Python 3 en segundo plano..."
    sudo apt-get install -y python3 &
fi

# Instalar pip para Python 3 si no está instalado
if ! command -v pip3 &> /dev/null; then
    echo "Instalando pip para Python 3 en segundo plano..."
    sudo apt-get install -y python3-pip &
fi

# Instalar pandas y matplotlib usando pip
if ! python3 -c 'import pandas' &> /dev/null || ! python3 -c 'import matplotlib' &> /dev/null; then
    echo "Instalando pandas y matplotlib en segundo plano..."
    pip3 install pandas matplotlib &
fi

# Instalar stress
if ! command -v stress &> /dev/null; then
    echo "Instalando stress en segundo plano..."
    sudo apt-get install -y stress &
fi

echo "Instalaciones en curso..."

# Esperar a que todos los procesos en segundo plano finalicen
wait

echo "Instalación completada."
