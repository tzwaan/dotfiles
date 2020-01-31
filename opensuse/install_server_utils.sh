#!/bin/bash


NGINX=$PWD/../nginx/server
NGINX_BACKUP_DIR=$PWD/../backup/nginx/
NGINX_ORIGINAL_CONFD=/etc/nginx/conf.d
NGINX_ORIGINAL_NGINX_CONF=/etc/nginx/nginx.conf
PHP_ORIGINAL_FPM=/etc/php7/fpm/php-fpm.conf
PHP_ORIGINAL_WWW=/etc/php7/fpm/php-fpm.d/www.conf

source config.cfg

echo "Installing server essentials"
echo "... Installing devel_basis packages"
zypper install -y --type pattern devel_basis

echo "... Installing packagees"
zypper install -y vim git python-pip python3-pip\
	htop python-devel python3-devel tig curl fish\
	tmux whois wget neovim cmake pyenv\
	zlib-devel bzip2 libbz2-devel libffi-devel libopenssl-devel\
	readline-devel sqlite3 sqlite3-devel xz xz-devel\
    moreutils nginx

echo "... Cloning pyenv virtualenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo "... Setting up nginx"

mv $NGINX_ORIGINAL_CONFD $NGINX_BACKUP_DIR
mv $NGINX_ORIGINAL_NGINX_CONF $NGINX_BACKUP_DIR

ln -sf $NGINX/conf.d $NGINX_ORIGINAL_CONFD
ln -sf $NGINX/nginx.conf $NGINX_ORIGINAL_NGINX_CONF

systemctl start nginx
systemctl enable nginx
systemctl status nginx
nginx -s reload

echo "... Setting up firewall"
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload

echo "... Installing certbot"
zypper install certbot python-certbot-nginx

echo "... Setting up mysql"
zypper install mariadb mariadb-client \
    php7-mysql php7-fpm php7-gd php7-mbstring
mysqladmin -u $mysql_root password $mysql_root_password

echo "... Setting up php"
mv $PHP_ORIGINAL_FPM $NGINX_BACKUP_DIR
mv $PHP_ORIGINAL_WWW $NGINX_BACKUP_DIR

ln -sf $NGINX/php-fpm.conf $PHP_ORIGINAL_FPM
ln -sf $NGINX/www.conf $PHP_ORIGINAL_WWW

systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm

nginx -s reload
