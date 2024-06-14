    #!/bin/bash

# Definir el archivo de salida para las estadísticas y el email de alerta
STATS_FILE="/path/to/stats.txt"
ALERT_EMAIL="admin@example.com"

# Función para obtener el uso de CPU
get_cpu_usage() {
    top -bn2 | grep "Cpu(s)" | tail -n 1 | awk '{print $2 + $4}'
}

# Función para obtener el uso de memoria y emitir alertas si es necesario
get_memory_usage() {
    mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Memory Usage: $mem_usage%"
    if (( $(echo "$mem_usage > 80" | bc -l) )); then
        echo "Memory usage is above 80%" | mail -s "Memory Alert" $ALERT_EMAIL
    fi
    if (( $(echo "$mem_usage > 90" | bc -l) )); then
        echo "Memory usage is above 90%, attempting to free up memory" | mail -s "Memory Critical Alert" $ALERT_EMAIL
        free_memory
    fi
    echo $mem_usage
}

# Función para obtener el uso del disco duro
get_disk_usage() {
    df -h | awk '$NF=="/"{printf "%s\t\t", $5}'
}

# Función para obtener los PIDs de los 3 procesos que más recursos ocupen
get_top_processes() {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 4
}

# Función para enviar alertas por correo electrónico
send_alert() {
    echo "$1" | mail -s "$2" $ALERT_EMAIL
}

# Función para liberar memoria
free_memory() {
    # Comando para liberar memoria cache
    sync; echo 3 > /proc/sys/vm/drop_caches
}

# Función para matar procesos con alto consumo de CPU
kill_high_cpu_processes() {
    # Obtener el PID del proceso con el mayor porcentaje de CPU
    high_cpu_process=$(ps -eo pid,%cpu --sort=-%cpu | head -n 2 | tail -n 1 | awk '{print $1}')
    cpu_usage=$(ps -eo pid,%cpu --sort=-%cpu | head -n 2 | tail -n 1 | awk '{print $2}')
    if (( $(echo "$cpu_usage > 90" | bc -l) )); then
        kill -9 $high_cpu_process
        send_alert "Killed process with PID $high_cpu_process due to high CPU usage" "CPU Usage Alert"
    fi
}

# Recopilar estadísticas
cpu_usage=$(get_cpu_usage)
memory_usage=$(get_memory_usage)
disk_usage=$(get_disk_usage)
top_processes=$(get_top_processes)

# Guardar estadísticas en el archivo
{
    echo "CPU Usage: $cpu_usage%"
    echo "Memory Usage: $memory_usage%"
    echo "Disk Usage: $disk_usage"
    echo "Top Processes:"
    echo "$top_processes"
} >> $STATS_FILE

# Comprobar alertas y tomar acciones
kill_high_cpu_processes
