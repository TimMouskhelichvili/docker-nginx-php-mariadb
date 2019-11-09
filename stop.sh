. ./variables.sh

#Stop running docker container
running=$(docker ps -aqf name=$CONTAINER_NAME -f status=running)
if [ "$running" ]; then
    docker stop $running
fi