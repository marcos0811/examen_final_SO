#!/bin/bash

# Generamos una carga en el CPU haciendo uso del paquete stress
stress --cpu $(nproc) --timeout 60 &

# Generar carga de memoria haciendo uso del paquete stress
stress --vm 1 --vm-bytes 1G --timeout 60 &

# Comando usado para generar una carga en el disco
dd if=/dev/zero of=/tmp/testfile bs=1M count=1024 oflag=direct &

# Esperamos a que todas las tareas en segundo plano terminen
wait
echo "Prueba de carga completada"
