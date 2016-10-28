#!/bin/sh
docker-machine start
eval $(docker-machine env)
docker-compose up -d
# forward geoserver ports in the background
docker-machine ssh default -f -N -L 3001:localhost:3001
docker-machine ssh default -f -N -L 9983:localhost:9983
docker-machine ssh default -f -N -L 8181:localhost:8181
docker-machine ssh default -f -N -L 6379:localhost:6379
docker-machine ssh default -f -N -L 5672:localhost:5672
docker-machine ssh default -f -N -L 15672:localhost:15672
