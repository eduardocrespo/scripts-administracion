#!/bin/bash
# -------------------------------------
# Usage: % ./wordpress_update2.sh
# Author: Eduarfo Crespo <eduardocrespo@gmail.com>
# -------------------------------------

# Comprobador de sintaxis estricta
set -e

# Establecemos prioridad baja
renice -n 19 $$

# Ruta donde se guardarán los backups
BACKUPPATH=~/backups

# Ruta al directorio donde se ubican las instalaciones de WordPress
SITESTORE=/var/www

# Creamos array de sites basado en los nombres de carpeta encontrados
SITELIST=($(ls -lh $SITESTORE | awk '{print $9}'))

# Nos aseguramos de que la carpeta para los backups existe
mkdir -p $BACKUPPATH

# Recorremos todas las instalaciones de WordPress indicadas en el array SITELIST
for SITE in ${SITELIST[@]};
do
    echo "Actualizando $SITE"

    # Entramos en la carpeta del WordPress que vamos a actualizar
    cd $SITESTORE/$SITE;

    # Fijamos permisos para poder hacer las actualizaciones
    sudo chown -R ecrespo:ecrespo $SITESTORE/$SITE 

    # Hacemos backup de la carpeta de WordPress 
    # tar -czf $BACKUPPATH/$SITE.tar .
    # Hacemos backup de la bbdd de WordPress 
    wp db export $BACKUPPATH/$SITE.sql --allow-root
    NOW=$(date +"%m-%d-%Y")
    tar -czf $BACKUPPATH/$SITE_$NOW.sql.gz $BACKUPPATH/$SITE.sql
    rm $BACKUPPATH/$SITE.sql

    # Ejecutamos la actualizacion completa
    # wp plugin update --all --allow-root;

    # Ejecutamos la actualizacion por módulos
    echo "Procesando: $SITESTORE/$SITE"

    echo "Actualizando plugins."
    wp plugin update --all --allow-root;

    # echo "Actualizando themes."
    # wp theme update --all --allow-root;

    echo "Actualizando Wordpress."
    wp core update && wp core update-db;

    # echo -n "Pulsa [ENTER] para asignar permisos definitivos...: "
    # read var_name
    # echo "You can go on!...."

    # Fijamos los permisos
    sudo chown -R www-data:google-sudoers $SITESTORE/$SITE
    sudo find $SITESTORE/$SITE -type f -exec chmod 644 {} +
    sudo find $SITESTORE/$SITE -type d -exec chmod 755 {} +
done

