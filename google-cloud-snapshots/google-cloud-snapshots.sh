#!/bin/bash
# Obtenemos la lista de discos dentro del proyecto y creamos un snapshot de cada uno
gcloud compute disks list --format='value(name,zone)'| while read DISK_NAME ZONE; do
  gcloud compute disks snapshot $DISK_NAME --snapshot-names sn$(date "+%y-%m-%d")-${DISK_NAME:0:31} --zone $ZONE
done
#
# Los snapshots son incrementales y no necesitan ser borrados, borrar snapshots provocará la fusión (merge) de los que queden, 
# por lo que el borrado no hace que se pierda nada.
# En caso de necesitar borrar snapshots antiguos, descomentar el siguiente fragmento (borrará los que sean más antiguos de 60 días)
#
#if [[ $(uname) == "Linux" ]]; then
#  from_date=$(date -d "-60 days" "+%y-%m-%d")
#else
#  from_date=$(date -v -60d "+%y-%m-%d")
#fi
#gcloud compute snapshots list --filter="creationTimestamp<$from_date" --regexp "(sn.*)" --uri | while read SNAPSHOT_URI; do
#   gcloud compute snapshots delete $SNAPSHOT_URI
#done
#
