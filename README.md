# database-backup-docker

![Build](https://github.com/0xERR0R/database-backup-docker/workflows/Build/badge.svg)

Creates backup of all schemas in MySQL/MariaDB.

Backup data will be stored in '/backup'. 

| Variable        | Example             | Description                                              |
|-----------------|---------------------|----------------------------------------------------------|
| MYSQL_HOST      | 192.178.178.28      | MySQL/MariaDB IP address or hostname                     |
| MYSQL_PORT      | 3306                | MySQL/MariaDB port                                       |
| MYSQL_USER      | root                | User for backup creation. Schould have access to all schemas which should be backed up (e.g. root)  |
| MYSQL_PASS      | passw0r!            | User's password                                          |
| MAX_BACKUPS     | 20                  | Number of backup files, older files will be deleted      |

## Complete example with docker-compose

Following `docker-compose.yml` starts initial backup. Backup file will be stored in a volume "backup" which is mounted via samba (NAS). Backup will run only on startup. You should trigger the execution per cron `docker-compose run backup` or by using of external tools like [crony](https://github.com/0xERR0R/crony). You can also use this image as a Kubernetes CronJob.

```yaml
version: "2"
services:
  backup:
    image: ghcr.io/0xerr0r/database-backup
    container_name: database-backup
    volumes:
      - backup:/backup
    environment:
      - MYSQL_HOST=192.168.178.xx
      - MYSQL_PORT=3307
      - MYSQL_USER=root
      - MYSQL_PASS=XXX
      - MAX_BACKUPS=20
      - TZ=Europe/Berlin
    labels:
      - crony.schedule="0 2 * * 1"
volumes: 
  backup:
     driver: local
     driver_opts:
        type: cifs
        o: username=XXX,password=XXX,rw
        device: //192.168.178.XXX/path_to/database-backup
```

Credits: Adopted from "https://github.com/fradelg/docker-mysql-cron-backup", thanks to `fradelg`
