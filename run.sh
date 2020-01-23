#!/bin/sh

echo 'STARTED NETWORK BOOTSTRAPPING'

export IMAGE_TAG=latest
COMPOSE_PROJECT_NAME=base-network

docker-compose -f  docker-compose.yaml up -d

echo 'COMPLETED'