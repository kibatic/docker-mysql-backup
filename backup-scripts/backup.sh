#!/bin/bash

MAX_BACKUPS=${MAX_BACKUPS}
BACKUP_NAME=$1_$(date +\%Y-\%m-\%d_\%H\%M\%S).sql
BACKUP_CMD="mysqldump -h $2 -u root -p$3 --all-databases > /backup/${BACKUP_NAME}"

echo "=> Backup started: ${BACKUP_NAME}"
if BACKUP_CMD ;then
    echo "   Backup succeeded"
else
    echo "   Backup failed"
    rm -rf /backup/${BACKUP_NAME}
fi

if [ -n "${MAX_BACKUPS}" ]; then
    while [ $(ls /backup -N1 | wc -l) -gt ${MAX_BACKUPS} ];
    do
        BACKUP_TO_BE_DELETED=$(ls /backup -N1 | sort | head -n 1)
        echo "   Backup ${BACKUP_TO_BE_DELETED} is deleted"
        rm -rf /backup/${BACKUP_TO_BE_DELETED}
    done
fi
echo "=> Backup done"
