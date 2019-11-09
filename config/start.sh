#!/bin/sh
if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "[i] MySQL data directory not found, creating initial DBs"
	chown -R mysql:mysql /var/lib/mysql

	mysql_install_db --user=mysql > /dev/null

	MYSQL_ROOT_PASSWORD='@kzsqk22CRW*rD9%J#qZ!kvQ'
	MYSQL_DATABASE='dev'

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'%' = PASSWORD('$MYSQL_ROOT_PASSWORD');
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
DROP DATABASE test;
EOF

	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "[i] Creating database: $MYSQL_DATABASE"
	    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
	fi

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
	rm -f $tfile
fi

if [ -d "/usr/share/webapps/phpmyadmin" ]; then
	mv /usr/share/webapps/phpmyadmin/ /usr/share/nginx/html
	chown -R nginx:nginx /usr/share/nginx/html/phpmyadmin
	chmod -R 644 /usr/share/nginx/html/phpmyadmin/config.inc.php
fi

nginx -g 'daemon off;' & php-fpm7 --nodaemonize & /usr/bin/mysqld --user=mysql --console