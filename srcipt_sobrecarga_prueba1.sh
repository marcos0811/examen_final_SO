#!/bin/bash

# Generar carga de CPU
stress --cpu $(nproc) --timeout 30 &

# Generar carga de memoria
stress --vm 1 --vm-bytes 1G --timeout 30 &

# Generar carga de disco
dd if=/dev/zero of=/tmp/testfile bs=1M count=1024 &

wait
echo "Prueba de carga completada"
