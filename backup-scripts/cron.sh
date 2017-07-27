#!/bin/bash
touch /mysql-backup.log
echo "${CRON_TIME} BACKUP_DB=${BACKUP_DB} && export BACKUP_DB && BACKUP_MAX=${BACKUP_MAX} && export BACKUP_MAX && BACKUP_OPTS=${BACKUP_OPTS} && export BACKUP_OPTS && /backup-scripts/backup-all.sh >> /mysql-backup.log 2>&1" > /crontab.conf
crontab /crontab.conf
echo "Running cron job"
exec cron -f
