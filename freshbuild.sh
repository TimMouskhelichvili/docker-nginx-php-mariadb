. ./variables.sh

#Build docker image (no cache)
docker build --no-cache -t $CONTAINER_NAME .