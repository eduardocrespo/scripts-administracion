#!/bin/bash
#
## VARIABLES DE CONFIGURACION
#

HOST=35.190.193.188
USER=root
PASS=
BACKUP_DIR=/home/ecrespo/backups
DIA=`date --date='1 days ago' +%Y%m%d`
HORA=`date +%H.%M.%S`
if [ ! -d $BACKUP_DIR"/"$HOST ]; then
  mkdir -p $BACKUP_DIR"/"$HOST
fi

# Backup de MySQL
# MYSQL_DBS=$(mysqlshow -h $HOST -u $USER -p$PASS | awk ' (NR > 2) && (/[a-zA-Z0-9]+[ ]+[|]/) && ( $0 !~ /mysql/) { print $2 }');
MYSQL_DBS=$(mysqlshow -h $HOST -u $USER | awk ' (NR > 2) && (/[a-zA-Z0-9]+[ ]+[|]/) && ( $0 !~ /mysql/) { print $2 }');

for DB in $MYSQL_DBS ; do
  echo "* Guardando backup MySQL para $DB@$HOST..."
  STR=$BACKUP_DIR"/"$HOST"/"$DB"_"$DIA"_"$HORA".sql"
  STR_TGZ=$BACKUP_DIR"/"$HOST"/"$DB"_"$DIA"_"$HORA".sql.tgz"
  echo "mysqldump -h $HOST -u $USER $DB > $STR"
  mysqldump -h $HOST -u $USER $DB > $STR
  echo " - Comprimiendo en tgz"
  tar -czf $STR_TGZ $STR
  echo " - Borrando temporal"
  rm $STR
  # echo "mysqldump -h $HOST -u $USER -p$PASS $DB > $STR"
  # mysqldump -h $HOST -u $USER -p$PASS $DB > $STR
done

