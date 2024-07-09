# examen_final_SO

### Pasos para Configurar y Ejecutar el Proyecto:
1. Descargamos el archivo zip:

Descargamos todos los codigos necesarios en un formato zip, despues nos dirigimos a la carpeta 'Descargas' o 'Download' segun su configuración, para descomprimirlo hacemos uso del comando:
 ```
 unzip examen_final_SO-main.zip
 ```
Una vez descomprimido procederemos a cambiar los permisos de los archivos .py y .sh, en caso de que quiera tener los archivos en otro lugar lo puede hacer haciendo uso de los siguientes comandos respectivamente.

```
chmod 700 archivo.sh  o archivo.py
mv examen_final_SO-main /home/usuario/destino
```
2.  Instalación de Paquetes: 

Ejecute el script instalar_paquetes.sh para instalar todos los paquetes necesarios para el proyecto.
```
./instalar_paquetes.sh
```
3. Configuración de Correos: 

Ejecute configuracion_correos.sh para configurar el correo emisor y la contraseña de aplicación sin espacios. Si usa Gmail, puede generar una contraseña de aplicación en [Google Account](https://myaccount.google.com/apppasswords).
```
./configuracion_correos.sh
```
En caso de querer trabajar con otro correo(hotmail, outlook , etc) debera cambiar el dominio smtp.dominio.com dentro del script

Si el correo ingresado y la contraseña son correctos se le enviara un mesanje de confirmacion, si le llego puede continuar caso contrario revise que los datos ingresados como la contraseña de aplicacion y el correo sean los correctos.

4. Inicio del Monitoreo: 

Una vez configurado el correo, ejecute monitoreo.sh para comenzar el monitoreo de la máquina virtual. Puede ajustar el directorio de almacenamiento de datos; por defecto, se guarda en el escritorio. Si su computadora está en otro idioma, asegúrese de cambiar el nombre del directorio tanto para el archivo '.csv' como para el '.log'.
```
./monitoreo.sh
```
El monitoreo se realiza cada 5 segundos durante un período de 1 minuto. Ajuste estos valores según sea necesario modificando el script monitoreo.sh.

5. Prueba de Sobrecarga (Opcional): 

Para verificar la efectividad del monitoreo, ejecute sobrecarga.sh, que simula una sobrecarga en la memoria RAM, CPU y disco duro.
```
./sobrecarga.sh
```
6. Generación de Gráficas: 

Para visualizar el consumo de memoria RAM y CPU en un tiempo definido, ejecute grafica.py. Asegúrese de actualizar la ruta del archivo .csv si ha cambiado su ubicación.
```
python3 grafica.py
```
