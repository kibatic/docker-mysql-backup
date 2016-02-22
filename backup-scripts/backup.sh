#!/bin/bash

while getopts ":n:h:p:d:m:" opt; do
  case $opt in
    n) CONTAINER_NAME=$OPTARG;;
    h) MYSQL_HOST=$OPTARG;;
    p) MYSQL_PASSWORD=$OPTARG;;
    d) BACKUP_DB=$OPTARG;;
    m) BACKUP_MAX=$OPTARG;;
    \?) echo "Invalid option: -$OPTARG" >&2;exit 1;;
  esac
done

BACKUP_NAME="${CONTAINER_NAME}_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).sql"
BACKUP_PATH="/backup/${CONTAINER_NAME}"
LOG_PREFIX="Backup => ${CONTAINER_NAME} :"

echo "$LOG_PREFIX start backuping <${BACKUP_DB:-all databases}> (${BACKUP_MAX:-"no"} maximum backups)"
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
