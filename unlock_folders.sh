#!/bin/bash

if [ "$1" != "" ]; then
	echo "[Desbloqueando directorios y ficheros de $1]"
	chown -R root "/var/www/$1/"
	chgrp -R www-data "/var/www/$1/httpdocs/wp-content/cache/"
	chgrp -R www-data "/var/www/$1/httpdocs/wp-content/advanced-cache.php"
	chgrp -R www-data "/var/www/$1/httpdocs/wp-content/wp-cache-config.php" 
	chown -R www-data:google-sudoers "/var/www/$1/httpdocs/wp-content/plugins/"
	chgrp -R google-sudoers "/var/www/$1/httpdocs/wp-content/themes/" 
	chown -R www-data:www-data "/var/www/$1/httpdocs/wp-content/uploads/"
	chown -R www-data:www-data "/var/www/$1"

        cd "/var/www/$1"
	# Permisos de los directorios a 0755
	find . -type d -exec chmod 0755 {} \;
	# Permisos de los ficheros a 0644
	find . -type f -exec chmod 0644 {} \;
	# Permisos especificos
	chmod -R 0775 "/var/www/$1/httpdocs/wp-content/cache/"
	chmod 0666 "/var/www/$1/httpdocs/wp-content/wp-cache-config.php"
	chmod -R 0775 "/var/www/$1/httpdocs/wp-content/uploads/"
	chmod -R 0775 "/var/www/$1/httpdocs/wp-content/plugins/"
	chmod -R 0775 "/var/www/$1/httpdocs/wp-content/themes/"
	echo "[Hecho]"
else
        echo "Falta el nombre del directorio a desbloquear: ./unlock_folders.sh directorio"
fi
