#!/bin/bash

CONTAINER_NAME=$1
MYSQL_HOST=$2
MYSQL_PASSWORD=$3
MAX_BACKUPS=$4
BACKUP_NAME=$1_$(date +\%Y-\%m-\%d_\%H\%M\%S).sql

echo "=> ${CONTAINER_NAME} : Backup started (${BACKUP_NAME})"

if mysqldump -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} --all-databases > /backup/${BACKUP_NAME} ;then
    echo "=> ${CONTAINER_NAME} : Backup succeeded"
else
    echo "=> ${CONTAINER_NAME} : Backup failed"
    rm -rf /backup/${BACKUP_NAME}
fi

echo "max backups : ${MAX_BACKUPS}"

if [ -n "${MAX_BACKUPS}" ]; then
    while [ $(ls /backup -N1 | wc -l) -gt ${MAX_BACKUPS} ];
    do
        BACKUP_TO_BE_DELETED=$(ls /backup -N1 | sort | head -n 1)
        echo "=> ${CONTAINER_NAME} : Backup ${BACKUP_TO_BE_DELETED} is deleted"
        rm -rf /backup/${BACKUP_TO_BE_DELETED}
    done
fi

echo "=> ${CONTAINER_NAME} : Backup done"
