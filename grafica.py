import pandas as pd
import matplotlib.pyplot as plt


# Leemos los datos desde el archivo CSV corregido
df = pd.read_csv('stats_prueab2.csv')


# Convertimos la columna 'Tiempo' a formato de fecha y hora
df['Timestamp'] = pd.to_datetime(df['Timestamp'])


# Graficar del consumo de memoria
plt.plot(df['Timestamp'], df['RAM Usage (%)'],
         color='blue', label='Memoria(%)', marker='o')

# Graficar cel uso de CPU
plt.plot(df['Timestamp'], df['CPU Usage (%)'],
         color='red', label='CPU(%)', marker='o')

# Configuracion de la grafica
plt.xlabel('Tiempo')
plt.ylabel('Uso (%)')
plt.title('Consumo de Memoria y CPU a lo largo del tiempo')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
