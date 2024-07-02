import pandas as pd
import matplotlib.pyplot as plt

# Cargar los datos desde el archivo CSV
archivo_csv = 'stats.csv'
df = pd.read_csv(archivo_csv)

# Convertir la columna de tiempo a tipo datetime
df['Timestamp'] = pd.to_datetime(df['Timestamp'])

# Ordenar por la columna de tiempo si no está ordenado
df = df.sort_values(by='Timestamp')

# Extraer los datos de interés
fechas = df['Timestamp']
uso_cpu = df['CPU Usage (%)']
uso_ram = df['RAM Usage (%)']

# Crear la gráfica
plt.figure(figsize=(10, 6))
plt.plot(fechas, uso_cpu, label='CPU Usage (%)', marker='o')
plt.plot(fechas, uso_ram, label='RAM Usage (%)', marker='o')

# Formatear la gráfica
plt.title('Uso de CPU y RAM')
plt.xlabel('Fecha y Hora')
plt.ylabel('Uso (%)')
plt.xticks(rotation=45)
plt.grid(True)
plt.legend()

# Mostrar la gráfica
plt.tight_layout()
plt.show()
