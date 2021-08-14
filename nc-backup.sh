#!/bin/bash

set -e

NCDIR="/var/www/nextcloud"
DATE=`date +"%Y-%m-%d--%H-%M"`
WWW_USER="www-data"
DB_USER="nextclouduser"
DB_NAME="nextcloud"


cd $NCDIR
echo "enabling maintenance mode"
sudo -u $WWW_USER php occ maintenance:mode --on
echo "creating backup directory ~/nextcloud-backup_$DATE"
mkdir ~/nextcloud-backup_$DATE
echo "creating database backup as ~/nextcloud-backup_$DATE/backup-nc-db_$DATE.sql"
echo "trying to log into database 'nextcloud' as user 'nextcloud' (password required)"
mysqldump --single-transaction -h localhost -u $DB_USER -p $DB_NAME > ~/nextcloud-backup_$DATE/backup-nc-db_$DATE.sql
#echo "creating backup of config directory as ~/nextcloud-backup_$DATE/backup-nc-conf_$DATE"
#cp -r config ~/nextcloud-backup_$DATE/backup-nc-conf_$DATE
echo "creating backup of nextcloud install directory as ~/nextcloud-backup_$DATE/backup-nc-dir_$DATE.tar.gz"
sudo tar -zcf ~/nextcloud-backup_$DATE/backup-nc-dir_$DATE.tar.gz .
echo "disabling maintenance mode"
sudo -u $WWW_USER php occ maintenance:mode --off
echo "backup created SUCCESSFULLY"
echo -e "$ ls -lah ~/nextcloud-backup_$DATE/ \n"
ls -lah ~/nextcloud-backup_$DATE/
