#!/bin/bash

service apache2 restart

mysql -h $MYSQL_PORT_3306_TCP_ADDR -u $MYSQL_USER -p$MYSQL_PASSWORD -e "create database IF NOT EXISTS $MYSQL_NAME;"
chown -R www-data /var/www
curl --data "hostname=$MYSQL_PORT_3306_TCP_ADDR&username=$MYSQL_USER&password=$MYSQL_PASSWORD&database=$MYSQL_NAME&adminname=$APP_ADMIN_EMAIL&adminemail=$APP_ADMIN_EMAIL&adminpass=$APP_ADMIN_PWD&adminrpass=$APP_ADMIN_PWD" http://127.0.0.1/install/install1.php
curl --data "title=$APP_TITLE&mainmail=$APP_ADMIN_EMAIL&rpublic=$APP_CAPTCHA_PUBLIC&rprivate=$APP_CAPTCHA_PRIVATE&smtp-host=$APP_SMTP_HOST&smtp-user=$APP_SMTP_USER&smtp-password=$APP_SMTP_PWD&smtp-port=$APP_SMTP_PORT" http://127.0.0.1/install/install2.php

rm -rf /var/www/install

service apache2 stop

apache2ctl -D FOREGROUND
