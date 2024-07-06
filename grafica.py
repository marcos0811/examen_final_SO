import pandas as pd
import matplotlib.pyplot as plt
import os


usuario = os.getloagin() # accedemos al nombre de usuario del sistema
df = pd.read_csv(f"/home/{usuario}/Escritorio/stats.csv") # ingresamos la ruta de eodne esta el archivo csv


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
plt.title('Consumo de la Memoria RAM y CPU a lo largo del tiempo')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
