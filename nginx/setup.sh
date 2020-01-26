#!/bin/bash

sudo zypper install -y nginx

BACKUP_DIR=$PWD/../backup/nginx/
ORIGINAL_CONFD=/etc/nginx/conf.d

sudo mv $ORIGINAL_CONFD $BACKUP_DIR

sudo ln -sf $PWD/conf.d $ORIGINAL_CONFD
