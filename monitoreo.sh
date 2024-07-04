#!/bin/bash

# Obtener el nombre del usuario actual
USER=$(whoami)

# Configuración del correo electrónico
read -p "Ingrese el correo al que quiere enviar la notificación: " EMAIL
SUBJECT="Alerta de uso de recursos"
LOGFILE="/home/$USER/Escritorio/stats.log"  # Ruta dinámica al escritorio
CSVFILE="/home/$USER/Escritorio/stats.csv"

# Pedir la contraseña de sudo una vez al inicio
if sudo -v; then
    echo "Autenticación sudo exitosa"
else
    echo "Autenticación sudo fallida"
    exit 1
fi

# Función para enviar correo electrónico
send_email() {
    local message=$1
    echo -e "Subject: $SUBJECT\n\n$message" | msmtp $EMAIL
    echo "Correo enviado a $EMAIL: $message"
}

# Crear archivo CSV y escribir encabezados
create_csv_file() {
    echo "Timestamp,CPU Usage (%),RAM Usage (%)" > $CSVFILE
}

# Verificar si el archivo CSV existe, si no, crearlo
if [ ! -f "$CSVFILE" ]; then
    create_csv_file
fi

# Función para guardar estadísticas en el archivo de log y CSV
log_stats() {
    echo "---- $(date) ----" >> $LOGFILE
    echo "Uso de CPU:" >> $LOGFILE
    top -bn1 | grep "Cpu(s)" >> $LOGFILE
    echo "" >> $LOGFILE
    echo "Uso de memoria:" >> $LOGFILE
    free -m >> $LOGFILE
    echo "" >> $LOGFILE
    echo "Uso de disco:" >> $LOGFILE
    df -h / >> $LOGFILE
    echo "" >> $LOGFILE
    echo "Top 3 procesos por uso de recursos:" >> $LOGFILE
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 4 >> $LOGFILE
    echo "" >> $LOGFILE

    # Obtener el uso de memoria y CPU en porcentaje
    mem_total=$(free | grep Mem | awk '{print $2}')
    mem_used=$(free | grep Mem | awk '{print $3}')
    mem_usage=$(echo "scale=2; $mem_used / $mem_total * 100" | bc)
    mem_usage=$(echo "$mem_usage" | sed 's/,/./g')
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage=$(echo "$cpu_usage" | sed 's/,/./g')

    # Agregar estadísticas a archivo CSV
    echo "$(date +%Y-%m-%d\ %H:%M:%S),$cpu_usage,$mem_usage" >> $CSVFILE
}

# Monitoreo del uso de memoria
check_memory() {
    mem_total=$(free | grep Mem | awk '{print $2}')
    mem_used=$(free | grep Mem | awk '{print $3}')
    mem_usage=$(echo "scale=2; $mem_used / $mem_total * 100" | bc)
    mem_usage=$(echo "$mem_usage" | sed 's/,/./g')
    if (( $(echo "$mem_usage > 90" | bc -l) )); then
        send_email "Uso de memoria crítico: ${mem_usage}%"
        # Intentar liberar memoria sin mostrar salida en pantalla
        sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    elif (( $(echo "$mem_usage > 80" | bc -l) )); then
        send_email "Uso de memoria alto: ${mem_usage}%"
    fi
}

# Monitoreo del uso de CPU
check_cpu() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage=$(echo "$cpu_usage" | sed 's/,/./g')
    if (( $(echo "$cpu_usage > 90" | bc -l) )); then
        send_email "Uso de CPU crítico: ${cpu_usage}%"
        # Matar procesos con alto uso de CPU sin mostrar salida en pantalla
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | awk '{if($5 > 90) print $1}' | xargs sudo kill -9 > /dev/null 2>&1
    fi
}

# Función principal de monitoreo
monitor() {
    # Crear archivo CSV y escribir encabezados si no existe
    if [ ! -f "$CSVFILE" ]; then
        create_csv_file
    fi

    while true; do
        log_stats
        check_memory
        check_cpu

        # Mantener la sesión sudo activa cada 5 minutos
        sudo -v
        sleep 30  # Reducimos el intervalo de monitoreo a 10 segundos
    done
}

# Ejecutar la función de monitoreo en segundo plano
monitor &
