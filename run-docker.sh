#!/bin/sh
docker-machine start
docker_ip=$(docker-machine ip)
eval $(docker-machine env)
docker-compose up -d
geoserver_url="http://"$docker_ip":8181/geoserver/rest"
export GEOSERVER_URL=$geoserver_url
