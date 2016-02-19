#!/bin/bash

CONTAINER_NAME=$1
MYSQL_HOST=$2
MYSQL_PASSWORD=$3
BACKUP_DB=$4
BACKUP_MAX=$5
BACKUP_NAME="$1_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).sql"
BACKUP_PATH="/backup/${CONTAINER_NAME}"
LOG_PREFIX="Backup => ${CONTAINER_NAME} :"

echo "$LOG_PREFIX start backuping <${BACKUP_DB}> (${BACKUP_MAX:-"no"} maximum backups)"
echo "$LOG_PREFIX <${BACKUP_NAME}>"

mkdir -p ${BACKUP_PATH}

if mysqldump -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} ${BACKUP_DB:---all-databases} --events > ${BACKUP_PATH}/${BACKUP_NAME} ;then
    echo "Backup => ${CONTAINER_NAME} : success"
else
    echo "Backup => ${CONTAINER_NAME} : failed"
    rm -rf ${BACKUP_PATH}/${BACKUP_NAME}
fi

if [ -n "${BACKUP_MAX}" ]; then
    while [ $(ls ${BACKUP_PATH} -N1 | wc -l) -gt ${BACKUP_MAX} ];
    do
        BACKUP_TO_DELETE=$(ls ${BACKUP_PATH} -N1 | sort | head -n 1)
        rm -rf ${BACKUP_PATH}/${BACKUP_TO_DELETE}
        echo "Backup => ${CONTAINER_NAME} : file <${BACKUP_TO_DELETE}> deleted"
    done
fi
