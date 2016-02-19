mysql-backup
===

/!\ This image is still in an experimental state /!\

TODO :
- redirect backup log to stdout
- a restore script
- a way to exclude a container

If you run this image on a Docker host, every container you're running using the "mysql" image will be backuped in "/backup/{container_name}/".

Simple way to test it :

```
docker-compose up -d
```

Configure mysql-backup
---

You can add the following environment variables to the "mysql-backup" container :

```
- BACKUP_MAX : The number of backups to keep. When reaching the limit, the old backup will be discarded. (default: no limit)
- BACKUP_DB  : The database name to dump. (default : `--all-databases`)
- CRON_TIME  : The interval of cron job to run mysqldump. `0 0 * * *` by default, which is every day at 00:00
```

Configure a specific container
---

You can add the following environment variables to a container to configure the way it will be backuped :

```
- BACKUP_MAX : The number of backups to keep. When reaching the limit, the old backup will be discarded. (default: no limit)
- BACKUP_DB  : The database name to dump. (default : `--all-databases`)
```


Thanks to Tumtum for their "tutumcloud/mysql-backup" image which this one is based on.
