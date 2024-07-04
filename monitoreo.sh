#!/bin/bash

# Obtener el nombre del usuario actual
USER=$(whoami)

# Se solicita el correo al que se le eviara la notificaion
read -p "Ingrese el correo al que quiere enviar la notificación: " EMAIL
# El nombre del directorio peude varias dependiedo el idido de la mauqina 
SUBJECT="Alerta de uso de recursos"
LOGFILE="/home/$USER/Escritorio/stats.log" 
CSVFILE="/home/$USER/Escritorio/stats.csv"

# Pedimos la contraseña de sudo una vez al inicio
if sudo -v; then
    echo "Autenticación sudo exitosa"
else
    echo "Autenticación sudo fallida"
    exit 1
fi

# Funcion creada para enviar los mensajes
send_email() {
    local message=$1
    echo -e "Subject: $SUBJECT\n\n$message" | msmtp $EMAIL
}

# Crear archivo CSV y escribir encabezados
create_csv_file() {
    echo "Timestamp,CPU Usage (%),RAM Usage (%)" > $CSVFILE
}

# Verificar si el archivo CSV existe, si no, crearlo para almacenar los valores del cpu,ram y hacer la grafica
if [ ! -f "$CSVFILE" ]; then
    create_csv_file
fi

# Funcion creada para guardar estadísticas en el archivo de log (texto plano) y CSV
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
    echo "Top 3 procesos por uso de CPU:" >> $LOGFILE
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 4 >> $LOGFILE
    echo "" >> $LOGFILE

    # Obtenemos el uso de memoria y CPU en porcentaje
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed -n 's/.*, *\([0-9.]*\)%* id.*/\1/p' | awk '{printf "%.2f", 100 - $1}')
    mem_usage=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100}')


    echo "$(date +%Y-%m-%d\ %H:%M:%S),$cpu_usage,$mem_usage" >> $CSVFILE
}

# Monitoreo del uso de memoria
check_memory() {
    mem_usage=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100}')
    if (( $(echo "$mem_usage > 90" | bc -l) )); then
        send_email "Uso de memoria crítico: ${mem_usage}%, tome acciones inmediatas."
        # liberamos la  memoria
        sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    elif (( $(echo "$mem_usage > 80" | bc -l) )); then
        send_email "Uso de memoria alto: ${mem_usage}%, precaución."
    fi
}

# Monitoreamos el uso de CPU
check_cpu() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed -n 's/.*, *\([0-9.]*\)%* id.*/\1/p' | awk '{printf "%.2f", 100 - $1}')
    if (( $(echo "$cpu_usage > 90" | bc -l) )); then
        send_email "Uso de CPU crítico: ${cpu_usage}%"
        # Matamos los procesos con alto uso de CPU
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | awk '{if($5 > 90) print $1}' | xargs sudo kill -9
    fi
}

# Funcion usada para el monitoreo en un bucle infinito
while true; do
    log_stats
    check_memory
    check_cpu

    # Mantenemos la sesión sudo activa cada 5 minutos
    sudo -v
    sleep 30  # Esperar 30 segundos entre cada ciclo de monitoreo
done
