CURRENT_USER=jasson #Change to your user
CONTAINER_NAME="env"
WORKING_DIR="/home/$CURRENT_USER/Dev:/usr/share/nginx/html/"
MARIADB_HOME_DIR="/home/$CURRENT_USER/Env_Data/MariaDB"
MARIADB_DIR="$MARIADB_HOME_DIR:/var/lib/mysql"

#Writting problem fix
mkdir -p $MARIADB_HOME_DIR
sudo chown -R $CURRENT_USER:$CURRENT_USER $MARIADB_HOME_DIR