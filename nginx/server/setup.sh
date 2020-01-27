#!/bin/bash

sudo zypper install -y nginx

BACKUP_DIR=$PWD/../../backup/nginx/server/
ORIGINAL_CONFD=/etc/nginx/conf.d
ORIGINAL_NGINX_CONF=/etc/nginx/nginx.conf

sudo mv $ORIGINAL_CONFD $BACKUP_DIR
sudo mv $ORIGINAL_NGINX_CONF $BACKUP_DIR

sudo ln -sf $PWD/conf.d $ORIGINAL_CONFD
sudo ln -sf $PWD/nginx.conf $ORIGINAL_NGINX_CONF

sudo systemctl start nginx.service
sudo nginx -s reload

# Setup firewall
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --reload

sudo zypper install certbot python-certbot-nginx
