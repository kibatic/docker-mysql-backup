#!/bin/bash

env > currentenv
echo "${CRON_TIME} /backup-scripts/backup-all.sh >> /mysql_backup.log 2>&1" > /crontab.conf
crontab /crontab.conf
echo "=> Running cron job"
exec cron -f
