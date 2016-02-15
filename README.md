mysql-backup
===

/!\ This image is still in an experimental state /!\

If you run this image on a Docker host, every container you're running using the "mysql" image will be backuped in "/backup".

Simple way to test it :

```
docker-compose up -d
```

TODO :
- add env vars doc
- restore script
- cron stdout
