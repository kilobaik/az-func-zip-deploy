#!/usr/bin/env bash

cat "$1/requirements.txt" > requirements.txt

docker build -f ./Dockerfile --build-arg REQ_FILE=requirements.txt -t az-func-layer .
CONTAINER_ID=$(docker run -d az-func-layer 2>/dev/null)

docker cp "$CONTAINER_ID:/app/.python_packages" "$1/.python_packages"
docker container rm "$CONTAINER_ID"

rm -f requirements.txt