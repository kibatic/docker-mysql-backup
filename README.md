mysql-backup
===

/!\ This image is still in an experimental state /!\

TODO :
- redirect backup log to stdout
- a restore script

If you run this image, every container with the label "mysql-backup" will be backuped in "/backup/{container_name}/".
For this to work the backup container must share a network with all database containers to backup.

Simple way to test it :

```
docker run --rm -v /path/to/your/storage:/backup -v /var/run/docker.sock:/tmp/docker.sock:ro kitpages/mysql-backup
```

Configure mysql-backup
---

You can add the following environment variables to the "mysql-backup" container :

```
- BACKUP_MAX  : The number of backups to keep. When reaching the limit, the old backup will be discarded. (default: no limit)
- BACKUP_DB   : The database name to dump. (default : `--all-databases`)
- BACKUP_OPTS : Optional parameters passed to mysqldump (e.g. `--opt`)
- CRON_TIME   : The interval of cron job to run mysqldump. `0 0 * * *` by default, which is every day at 00:00
```

Configure a specific container
---

You can add the following environment variables to a container to configure the way it will be backuped :

```
- BACKUP_MAX : The number of backups to keep. When reaching the limit, the old backup will be discarded. (default: no limit)
- BACKUP_DB  : The database name to dump. (default : `--all-databases`)
- BACKUP_OPTS : Optional parameters passed to mysqldump (e.g. `--opt`)
```


Thanks to Tutum for their "tutumcloud/mysql-backup" image which this one is based on.
