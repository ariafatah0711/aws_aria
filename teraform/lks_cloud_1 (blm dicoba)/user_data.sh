#!/bin/bash

#
# author: @itsgitz - <Anggit M Ginanjar>

DOMAIN_NAME="modul1.kotakserver.my.id"
DOCUMENT_ROOT="/var/www/html"
NGINX_CONFIGURATION_DIR="/etc/nginx"
GIST_URL="https://gist.githubusercontent.com/itsgitz/d062c142d94eba2381eca6e1a6d9c0ed/raw"

# Add Ondrej's PPA for installing the latest PHP version
add-apt-repository ppa:ondrej/php -y

# update the OS applications and dependencies
apt-get update -y

# install nginx
apt-get install nginx -y

# install php
apt-get install php8.3 php8.3-cli php8.3-fpm -y

nginx -v
php -v

# remove default Nginx html file
rm $DOCUMENT_ROOT/index.html
rm $DOCUMENT_ROOT/index.nginx-debian.html

# remove default Nginx configuration files
rm "$NGINX_CONFIGURATION_DIR/sites-available/default"
rm "$NGINX_CONFIGURATION_DIR/sites-enabled/default"

# download index.php from the gist
wget $GIST_URL -O $DOCUMENT_ROOT/index.php

chown ubuntu:www-data $DOCUMENT_ROOT/index.php
chmod 775 $DOCUMENT_ROOT/index.php

cat <<EOF > $NGINX_CONFIGURATION_DIR/sites-available/$DOMAIN_NAME
server {
        listen 80 default_server;
        listen [::]:80 default_server; 

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.php;

		access_log /var/log/nginx/$DOMAIN_NAME-access.log;
		error_log /var/log/nginx/$DOMAIN_NAME-error.log;

        server_name $DOMAIN_NAME;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files \$uri \$uri/ =404;
        }

        # pass PHP scripts to FastCGI server
        #
        location ~ \.php$ {
               include snippets/fastcgi-php.conf;
        
               # With php-fpm (or other unix sockets):
               fastcgi_pass unix:/run/php/php-fpm.sock; 
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        location ~ /\.ht {
               deny all;
        }
}
EOF

ln -s "$NGINX_CONFIGURATION_DIR/sites-available/$DOMAIN_NAME" \
	"$NGINX_CONFIGURATION_DIR/sites-enabled/"

# restart web server
systemctl restart nginx