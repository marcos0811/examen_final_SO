#!/bin/bash

# Generamos una carga en el CPU haciendo uso del pauqete stress
stress --cpu $(nproc) --timeout 60 &

# Generar carga de memoria hacinedo uso del paquete stress
stress --vm 1 --vm-bytes 1G --timeout 60 &

# comando usado para generar una carga en el disco
dd if=/dev/zero of=/tmp/testfile bs=1M count=1024 oflag=direct &

# Esperar a que todas las tareas en segundo plano terminen
wait
echo "Prueba de carga completada"
