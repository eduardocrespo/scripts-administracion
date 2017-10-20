#!/bin/bash
# -------------------------------------
# Usage: % ./wordpress_update.sh
# Author: Eduarfo Crespo <eduardocrespo@gmail.com>
# -------------------------------------

# Comprobador de sintaxis estricta
set -e

# Establecemos prioridad baja
renice -n 19 $$

WPS=(
"/var/www/html/"
#"/path/to/wordpress2/"
)

# Recorremos todas las instalaciones de WP indicadas en el array WPS
for i in $WPS
do

  echo "Procesando: $i"
  cd $i

  echo "Otorgando permisos a $i"
  sudo chown -R ecrespo:ecrespo $i

  echo "Actualizando plugins."
  wp plugin update --all

  echo "Actualizando themes."
  wp theme update --all

  echo "Actualizando Wordpress."
  wp core update && wp core update-db

  echo "Estableciendo permisos definitivos a $i"
  sudo chown -R www-data:google-sudoers $i

done
