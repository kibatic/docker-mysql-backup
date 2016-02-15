#!/bin/bash

CONTAINER_NAME=$1
MYSQL_HOST=$2
MYSQL_PASSWORD=$3
MAX_BACKUPS=$4
BACKUP_NAME=$1_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).sql

echo "Backup => ${CONTAINER_NAME} : start (${BACKUP_NAME}) with ${MAX_BACKUPS} maximum backups"

if mysqldump -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} --all-databases --events > /backup/${BACKUP_NAME} ;then
    echo "Backup => ${CONTAINER_NAME} : ok"
else
    echo "Backup => ${CONTAINER_NAME} : failed"
    rm -rf /backup/${BACKUP_NAME}
fi

if [ -n "${MAX_BACKUPS}" ]; then
    while [ $(ls /backup -N1 | wc -l) -gt ${MAX_BACKUPS} ];
    do
        BACKUP_TO_DELETE=$(ls /backup -N1 | sort | head -n 1)
        rm -rf /backup/${BACKUP_TO_DELETE}
        echo "Backup => ${CONTAINER_NAME} : ${BACKUP_TO_DELETE} deleted"
    done
fi
