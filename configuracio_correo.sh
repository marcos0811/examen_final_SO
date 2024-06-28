#!/bin/bash

# Verificamos si msmtp está instalado y, si no lo está, instalarlo
if ! command -v msmtp &> /dev/null
then
    echo "Instalando msmtp..."
    sudo apt-get update
    sudo apt-get install -y msmtp
fi

# Solicitamos la dirección de correo electrónico y la contraseña de aplicación, la cual se le debe de scar de gmail
read -p "Ingresa tu dirección de correo electrónico: " email
read -s -p "Ingresa tu contraseña de aplicación: " password
echo ""

# Creamos el archivo ~/.msmtprc con los parámetros proporcionados
#En caso de que se quiera trabajar con otro domino se deeb de cambiar smtp.dominio.com
cat <<EOF > ~/.msmtprc
account default
host smtp.gmail.com   
port 587
auth on
user $email
password $password
from $email
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log
EOF

# Creamos el archivo de log
touch ~/.msmtp.log

# Establecemos los permisos adecuados para el archivo ~/.msmtprc
chmod 600 ~/.msmtprc
# mensaje de confirmacion del envio de correo
echo "Configuración de msmtp completada. Ahora puedes enviar correos electrónicos desde la línea de comandos con msmtp."
#Mandamos un mensaje de coonfirmacion
echo -e "Subject: Mesanje de incio\n\nUsted a realizado una exlenete configuracion para el envio de correos." > /tmp/testemail.txt
msmtp $email < /tmp/testemail.txt




