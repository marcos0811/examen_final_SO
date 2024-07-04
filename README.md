# examen_final_SO
los paquetes a instalar son :

-sudo apt-get update

-sudo apt-get install streess

Ejecutar el codigo configuracion_correos.sh y poner el correo emisor del mensaje y la contraseña de aplicacion, puede sacar la contraseña de seguirdad en el siguiente link https://myaccount.google.com/apppasswords en caso de trabajar con gmail.

En caso de querer trabajar con otro correo debera cambiar el dominio smtp.dominio.com

Una vez ya instalado el paquete msmtp con el script anterior se le enviara un mensaje de confirmacion al correo

Si le llego procederemos a ejecutar el codigo monitoreo.sh para empezar con el monitoreo de la mauqina virtual

Para comprobar la efectividad del script anterior podemos ejecutar el codigo sobrecarga.sh el cual contiene
comandos especificos para la sobrecarga del sistema

Adicional a ello se agrego el codigo usado en python para poder visualizar de una mejor manera el uso de la CPU y la RAM en el sistema, 
la grafica muestra como al generar la sobrecarga, se pone en acccion el script monitoreo matando los procesos que generan la sobrecarga
y asi bajando el consumo de estos.
