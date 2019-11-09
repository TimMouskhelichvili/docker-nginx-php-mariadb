FROM alpine:latest

#Update & Install NGINX, CURL, NodeJs NPM, MariaDB, MariaDB-Client
RUN apk update && apk upgrade && apk add nginx curl nodejs npm mariadb mariadb-client

#Install PHP + PHP extensions
RUN apk add php7 php7-json php7-zlib php7-xml php7-pdo php7-phar php7-openssl php7-session \
            php7-pdo_mysql php7-mysqli php7-soap php7-gmp php7-zip php7-memcached\
            php7-gd php7-iconv php7-mcrypt php7-apcu php7-bcmath php7-bz2 \
            php7-curl php7-openssl php7-dom php7-ctype php7-odbc php7-xmlrpc \
            php7-gettext php7-xmlreader php7-fpm php7-opcache php7-mbstring

#Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Install PhpMyAdmin
RUN apk add phpmyadmin

#Setup site directory
RUN mkdir -p /run/nginx && mkdir -p /var/run/nginx-cache/localhost && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

#Fix permission error & Clean Up
RUN chmod -R 777 /var/tmp && rm -rf /var/cache/apk/*

#Copy All Files
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/_fastcgi.conf /etc/nginx/_fastcgi.conf
COPY config/nginx/_fastcgi_cache_skip.conf /etc/nginx/_fastcgi_cache_skip.conf
COPY config/nginx/_fastcgi_cache_params.conf /etc/nginx/_fastcgi_cache_params.conf
COPY config/nginx/_gzip_static.conf /etc/nginx/_gzip_static.conf
COPY config/nginx/_gzip.conf /etc/nginx/_gzip.conf
COPY config/nginx/_headers.conf /etc/nginx/_headers.conf
COPY config/nginx/_ssl.conf /etc/nginx/_ssl.conf
COPY config/nginx/_wordpress.conf /etc/nginx/_wordpress.conf
COPY config/nginx/sites /etc/nginx/sites
COPY config/phpmyadmin/config.inc.php /usr/share/webapps/phpmyadmin/config.inc.php
COPY config/php/settings.ini /etc/php7/conf.d/settings.ini
COPY config/mariadb/my.cnf /etc/mysql/my.cnf
COPY config/start.sh /start.sh

EXPOSE 80 443

CMD ["/bin/sh", "/start.sh"]