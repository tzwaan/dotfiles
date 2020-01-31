#!/bin/bash


NGINX=$PWD/../nginx/server
NGINX_BACKUP_DIR=$PWD/../backup/nginx/
NGINX_ORIGINAL_CONFD=/etc/nginx/conf.d
NGINX_ORIGINAL_NGINX_CONF=/etc/nginx/nginx.conf
PHP_ORIGINAL_FPM=/etc/php7/fpm/php-fpm.conf
PHP_ORIGINAL_WWW=/etc/php7/fpm/php-fpm.d/www.conf

source config.cfg

echo -e "\n\nInstalling server essentials"
echo -e "\n\nInstalling devel_basis packages"
zypper install -y --type pattern devel_basis

echo -e "\n\nInstalling packagees"
zypper install -y vim git python-pip python3-pip\
	htop python-devel python3-devel tig curl fish\
	tmux whois wget neovim cmake pyenv\
	zlib-devel bzip2 libbz2-devel libffi-devel libopenssl-devel\
	readline-devel sqlite3 sqlite3-devel xz xz-devel\
    moreutils nginx

echo -e "\n\nCloning pyenv virtualenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo -e "\n\nSetting up nginx"

echo -e "\n\nMaking backups of existing files"
declare -a files=("$NGINX_ORIGINAL_CONFD" "$NGINX_ORIGINAL_NGINX_CONF" \
    "$NGINX_ORIGINAL_CONFD" "$NGINX_ORIGINAL_NGINX_CONF")

for file in ${files[@]}; do
    if [[ ( -f $file || -d $file ) $$ ! -L $file ]]
    then
        echo -e "  Moving $file to $NGINX_BACKUP_DIR"
        mv $file $NGINX_BACKUP_DIR
    else
        echo -e "  $file is already a symbolic link. No backup required"
    fi
done

ln -sf $NGINX/conf.d $NGINX_ORIGINAL_CONFD
ln -sf $NGINX/nginx.conf $NGINX_ORIGINAL_NGINX_CONF

systemctl start nginx
systemctl enable nginx
systemctl status nginx
nginx -s reload

echo -e "\n\nSetting up firewall"
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload

echo -e "\n\nInstalling certbot"
zypper install certbot python-certbot-nginx

echo -e "\n\nSetting up mysql"
zypper install mariadb mariadb-client \
    php7-mysql php7-fpm php7-gd php7-mbstring

mysqladmin -u $mysql_root password $mysql_root_password

echo -e "\n\nSetting up php"

ln -sf $NGINX/php-fpm.conf $PHP_ORIGINAL_FPM
ln -sf $NGINX/www.conf $PHP_ORIGINAL_WWW

systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm

nginx -s reload
