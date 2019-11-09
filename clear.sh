#Stop running docker containers
docker stop $(docker ps -a -q)

#Remove all docker containers
docker rm $(docker ps -a -q)

#Remove all docker images
docker rmi $(docker images -q)

#Remove all others stuff
docker system prune --all --force --volumes