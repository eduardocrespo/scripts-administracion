#!/bin/bash

if [ "$1" != "" ]; then
	declare -a rutas=("/var/www/$1" "/var/www/$1/httpdocs/wp-content/themes/site" "/var/www/$1/httpdocs/wp-content/plugins" "/var/www/$1/httpdocs/wp-content/uploads" "/var/www/$1/httpdocs/wp-content/cache")

	## Recorremos el array rutas
	echo ""
	for ruta in "${rutas[@]}"
	do
		perm=$(stat -c '%a' "$ruta")
		owner=$(stat -c '%U' "$ruta")
		group=$(stat -c '%G' "$ruta")
		if [ "$perm" == "2755" ];
		then
			msg=""
		else
			msg=""
		fi
       		echo "$ruta $perm $owner:$group $msg"
	done
	echo ""
else
        echo "Falta el nombre del directorio a comprobar: ./check.sh directorio"
fi
