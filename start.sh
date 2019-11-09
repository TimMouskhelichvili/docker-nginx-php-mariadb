. ./variables.sh

#Stop running docker container
running=$(docker ps -aqf name=$CONTAINER_NAME -f status=running)
if [ "$running" ]; then
    docker stop $running
fi

#Run docker container
id=$(docker ps -aqf "name=$CONTAINER_NAME")
if [ -z "$id" ]; then
    docker run --name $CONTAINER_NAME -d -p 80:80 -v $WORKING_DIR -v $MARIADB_DIR $CONTAINER_NAME
else
    docker start $id
fi

#Fix mysql permission error
docker exec -it $CONTAINER_NAME chown -R mysql:mysql /var/lib/mysql