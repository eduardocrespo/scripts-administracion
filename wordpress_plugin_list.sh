#!/bin/bash
# -------------------------------------
# Usage: % ./wordpress_plugin_list.sh
# Author: Eduarfo Crespo <eduardocrespo@gmail.com>
# -------------------------------------

# Comprobador de sintaxis estricta
set -e

# Establecemos prioridad baja
renice -n 19 $$

# Ruta al directorio donde se ubican las instalaciones de WordPress
SITESTORE=/var/www/darktv.es

# Creamos array de sites basado en los nombres de carpeta encontrados
SITELIST=($(ls -lh $SITESTORE | grep "^d" | awk '{print $9}'))

# Recorremos todas las instalaciones de WordPress indicadas en el array SITELIST
for SITE in ${SITELIST[@]};
do
    # Entramos en la carpeta del WordPress que vamos a revisar
    cd $SITESTORE/$SITE;

    # Listado de plugins
    wp plugin list
done
