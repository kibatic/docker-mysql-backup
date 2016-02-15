#!/bin/bash

echo "${CRON_TIME} /backup-scripts/backup-all.sh >> /mysql-backup.log 2>&1" > /crontab.conf
crontab /crontab.conf
echo "Running cron job"
exec cron -f && tail -f /mysql-backup.log
