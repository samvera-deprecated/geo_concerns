#!/bin/sh
docker-machine start
eval $(docker-machine env)
docker-compose up -d
# forward geoserver ports in the background
docker-machine ssh default -f -N -L 8181:localhost:8181
